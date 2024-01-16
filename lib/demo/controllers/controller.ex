defmodule Demo.Controllers.Controller do
  @moduledoc """
  controllers schema
  """
  use Ecto.Schema

  @type t :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: integer(),
          mode: String.t(),
          name: String.t(),
          site: Demo.Sites.Site.t(),
          site_id: integer(),
          type: String.t()
        }

  schema "controllers" do
    field :name, :string
    field :mode, :string
    field :type, :string

    belongs_to :site, Demo.Sites.Site
  end
end
