defmodule Demo.Sites.Site do
  use Ecto.Schema

  import Ecto.Changeset

  schema "sites" do
    field :name, :string
    field :address, :string
    field :billing_status, Ecto.Enum, values: [:paid, :unpaid], default: :unpaid
    field :has_weather_station, :boolean, default: false
    field :controllers_count, :integer, virtual: true

    has_many :controllers, Demo.Controllers.Controller
  end

  def update_changeset(%__MODULE__{} = site, attributes) do
    allowed_fields = ~w(
      has_weather_station
      billing_status
     )a

    cast(site, attributes, allowed_fields)
  end
end
