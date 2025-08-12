defmodule Pento.Catalog.Products do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(products, attrs) do
    products
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0)
  end

  def unit_price_changeset(product, attrs) do
    cast(product, attrs, [:unit_price])
    |> case do
      %{changes: %{unit_price: price}} = changeset ->
        cond do
          price < Map.get(product, :unit_price) ->
            changeset

          true ->
            add_error(changeset, :unit_price, "did not change")
        end

      %{} = changeset ->
        add_error(changeset, :unit_price, "did not change")
    end
  end
end
