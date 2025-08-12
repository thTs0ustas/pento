defmodule Pento.CatalogTest do
  use Pento.DataCase

  alias Pento.Catalog

  describe "products" do
    alias Pento.Catalog.Products

    import Pento.CatalogFixtures

    @invalid_attrs %{name: nil, description: nil, unit_price: nil, sku: nil}

    test "list_products/0 returns all products" do
      products = products_fixture()
      assert Catalog.list_products() == [products]
    end

    test "get_products!/1 returns the products with given id" do
      products = products_fixture()
      assert Catalog.get_products!(products.id) == products
    end

    test "create_products/1 with valid data creates a products" do
      valid_attrs = %{name: "some name", description: "some description", unit_price: 120.5, sku: 42}

      assert {:ok, %Products{} = products} = Catalog.create_products(valid_attrs)
      assert products.name == "some name"
      assert products.description == "some description"
      assert products.unit_price == 120.5
      assert products.sku == 42
    end

    test "create_products/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_products(@invalid_attrs)
    end

    test "update_products/2 with valid data updates the products" do
      products = products_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", unit_price: 456.7, sku: 43}

      assert {:ok, %Products{} = products} = Catalog.update_products(products, update_attrs)
      assert products.name == "some updated name"
      assert products.description == "some updated description"
      assert products.unit_price == 456.7
      assert products.sku == 43
    end

    test "update_products/2 with invalid data returns error changeset" do
      products = products_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_products(products, @invalid_attrs)
      assert products == Catalog.get_products!(products.id)
    end

    test "delete_products/1 deletes the products" do
      products = products_fixture()
      assert {:ok, %Products{}} = Catalog.delete_products(products)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_products!(products.id) end
    end

    test "change_products/1 returns a products changeset" do
      products = products_fixture()
      assert %Ecto.Changeset{} = Catalog.change_products(products)
    end
  end
end
