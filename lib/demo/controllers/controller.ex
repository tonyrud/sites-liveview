defmodule Demo.Controllers.Controller do
  use Ecto.Schema

  schema "controllers" do
    field :name, :string
    field :mode, :string
    field :type, :string

    belongs_to :site, Demo.Sites.Site
  end
end
