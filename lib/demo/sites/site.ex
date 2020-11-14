defmodule Demo.Site do
  use Ecto.Schema

  schema "sites" do
    field :name, :string
    field :address, :string
    field :billing_status, :string
    field :has_weather_station, :boolean

    has_many :controllers, Demo.Controller
  end
end
