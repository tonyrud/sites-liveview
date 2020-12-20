defmodule Demo.Test.Fixtures do
  alias Demo.{
    Repo,
    Sites.Site
  }

  def make_many(count, schema, p \\ %{}), do: for(_ <- 1..count, do: make(schema, p))

  def make(:site) do
    site = %Site{
      id: "1234",
      name: "Site Name",
      address: "Address",
      billing_status: :paid,
      has_weather_station: true,
      lng_lat_point: %Geo.Point{coordinates: {34.55, -25.32}, srid: 4326}
    }

    Repo.insert!(site)
  end
end
