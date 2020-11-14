defmodule Demo.Controller do
  use Ecto.Schema

  schema "controllers" do
    field :name, :string
    # field :mode, Ecto.Enum, values: [:smart, :basic]
    field :mode, :string
    field :type, :string

    belongs_to :site, Demo.Site
  end
end
