defmodule Demo.ZipCodes.ZipCode do
  use Ecto.Schema

  import Ecto.Changeset

  schema "zip_codes" do
    field :zip_code, :string
    field :city, :string
    field :state, :string
    field :lng_lat_point, Geo.PostGIS.Geometry
  end

  def create_changeset(%__Module__{} = zip_code, attrs \\ %{}) do
    all_fields = [:zip_code, :city, :state, :lng_lat_point]

    zip_code
    |> cast(attrs, all_fields)
    |> validate_required(all_fields)
  end
end
