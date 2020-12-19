defmodule Demo.Controllers.Controller do
  @moduledoc """
  controllers schema
  """
  use Ecto.Schema

  schema "controllers" do
    field :name, :string
    field :mode, :string
    field :type, :string

    belongs_to :site, Demo.Sites.Site
  end
end
