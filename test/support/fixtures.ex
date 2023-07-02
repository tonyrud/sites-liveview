defmodule Demo.Test.Fixtures do
  @moduledoc false

  alias Demo.Controllers.Controller
  alias Demo.Repo
  alias Demo.Sites.Site

  def make_many(count, schema, data \\ %{}), do: for(_ <- 1..count, do: make(schema, data))

  def make(m, p \\ %{})

  def make(:site, site) do
    site_params = %Site{
      id: Enum.random(1..999),
      name: Map.get(site, :name, Faker.Company.bs()),
      address: Map.get(site, :address, Faker.Address.street_address()),
      billing_status: Map.get(site, :billing_status, Enum.random([:paid, :unpaid])),
      has_weather_station: Map.get(site, :has_weather_station, Enum.random([true, false])),
      lng_lat_point: %Geo.Point{coordinates: {34.55, -25.32}, srid: 4326}
    }

    site = Repo.insert!(site_params)

    # create random controllers count on site
    make_many(Enum.random(0..5), :controller, site)

    site
  end

  def make(:controller, site) do
    controller = %Controller{
      id: id(),
      name: Faker.Company.bs(),
      mode: Enum.random(["basic", "smart"]),
      type: Enum.random(["cellular", "wifi"]),
      site_id: site.id
    }

    Repo.insert!(controller)
  end

  def id do
    Enum.random(1..999) + Enum.random(1..999)
  end
end
