defmodule PentoWeb.ProductsLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Catalog

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage products records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="products-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:unit_price]} type="number" label="Unit price" step="any" />
        <.input field={@form[:sku]} type="number" label="Sku" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Products</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{products: products} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Catalog.change_products(products))
     end)}
  end

  @impl true
  def handle_event("validate", %{"products" => products_params}, socket) do
    changeset = Catalog.change_products(socket.assigns.products, products_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"products" => products_params}, socket) do
    save_products(socket, socket.assigns.action, products_params)
  end

  defp save_products(socket, :edit, products_params) do
    case Catalog.update_products(socket.assigns.products, products_params) do
      {:ok, products} ->
        notify_parent({:saved, products})

        {:noreply,
         socket
         |> put_flash(:info, "Products updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_products(socket, :new, products_params) do
    case Catalog.create_products(products_params) do
      {:ok, products} ->
        notify_parent({:saved, products})

        {:noreply,
         socket
         |> put_flash(:info, "Products created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
