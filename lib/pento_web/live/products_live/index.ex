defmodule PentoWeb.ProductsLive.Index do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Catalog.Products

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :products_collection, Catalog.list_products())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Products")
    |> assign(:products, Catalog.get_products!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Products")
    |> assign(:products, %Products{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:products, nil)
  end

  @impl true
  def handle_info({PentoWeb.ProductsLive.FormComponent, {:saved, products}}, socket) do
    {:noreply, stream_insert(socket, :products_collection, products)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    products = Catalog.get_products!(id)
    {:ok, _} = Catalog.delete_products(products)

    {:noreply, stream_delete(socket, :products_collection, products)}
  end
end
