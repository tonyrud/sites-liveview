defmodule Demo.Sites.Site do
  use Ecto.Schema

  import Ecto.Changeset

  @required_fields ~w(
    address
    name
  )a

  @optional_fields ~w(
    billing_status
    has_weather_station
    lng_lat_point
   )a

  schema "sites" do
    field :address, :string
    field :billing_status, Ecto.Enum, values: [:paid, :unpaid], default: :unpaid
    field :has_weather_station, :boolean, default: false
    field :lng_lat_point, Geo.PostGIS.Geometry
    field :name, :string

    field :controllers_count, :integer, virtual: true
    field :distance_in_miles, :float, virtual: true

    has_many :controllers, Demo.Controllers.Controller

    timestamps()
  end

  def create_changeset(%__MODULE__{} = site, attributes \\ %{}) do
    site
    |> cast(attributes, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_lat_lng(attributes)
  end

  def update_changeset(%__MODULE__{} = site, attributes \\ %{}) do
    site
    |> cast(attributes, @required_fields ++ @optional_fields)
    |> validate_lat_lng(attributes)
  end

  defp validate_lat_lng(changeset, attributes) do
    lat = Map.get(attributes, :lat)
    lng = Map.get(attributes, :lng)

    lat_range = %{high: 90, low: -90}
    lng_range = %{high: 180, low: -180}

    in_lat_ranges = lat < lat_range.high and lat > lat_range.low
    in_lng_ranges = lng < lng_range.high and lng > lng_range.low

    if lat != nil and lng != nil do
      if in_lat_ranges and in_lng_ranges do
        point = %Geo.Point{coordinates: {lng, lat}, srid: 4326}
        put_change(changeset, :lng_lat_point, point)
      else
        changeset
        |> check_range(lat, :latitude, lat_range)
        |> check_range(lng, :longitude, lng_range)
      end
    else
      changeset
    end
  end

  defp check_range(changeset, val, key, %{high: h, low: l}) when val > h or val < l do
    add_error(
      changeset,
      key,
      "got number #{val}...#{key} must be number between #{inspect(h..l)}"
    )
  end

  defp check_range(changeset, _val, _key, _ranges) do
    changeset
  end
end
