defmodule Demo.Sites.Site do
  use Ecto.Schema

  import Ecto.Changeset

  schema "sites" do
    field :address, :string
    field :billing_status, Ecto.Enum, values: [:paid, :unpaid], default: :unpaid
    field :has_weather_station, :boolean, default: false
    field :lng_lat_point, Geo.PostGIS.Geometry
    field :name, :string

    field :controllers_count, :integer, virtual: true
    # TODO: this should be a virtual field, but returns nil from Repo.load
    field :distance_in_miles, :float

    has_many :controllers, Demo.Controllers.Controller
  end

  def update_changeset(%__MODULE__{} = site, attributes \\ %{}) do
    allowed_fields = ~w(
      billing_status
      has_weather_station
     )a

    cast(site, attributes, allowed_fields)
  end
end
