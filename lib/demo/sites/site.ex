defmodule Demo.Sites.Site do
  use Ecto.Schema

  schema "sites" do
    field :name, :string
    field :address, :string
    field :billing_status, Ecto.Enum, values: [:paid, :unpaid]
    # field :billing_status, :string
    field :has_weather_station, :boolean
    field :controllers_count, :integer, virtual: true

    has_many :controllers, Demo.Controllers.Controller
  end
end
