defmodule Pento.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Catalog` context.
  """

  @doc """
  Generate a unique products sku.
  """
  def unique_products_sku, do: System.unique_integer([:positive])

  @doc """
  Generate a products.
  """
  def products_fixture(attrs \\ %{}) do
    {:ok, products} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        sku: unique_products_sku(),
        unit_price: 120.5
      })
      |> Pento.Catalog.create_products()

    products
  end
end
