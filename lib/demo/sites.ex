defmodule Demo.Sites do
  @moduledoc """
  Context module for Sites
  """
  import Ecto.Query

  alias Demo.{
    Repo,
    Sites.Site,
    Controllers.Controller
  }

  def all do
    Site
    |> Repo.all()
    |> Repo.preload(:controllers)
  end

  def all(params) when is_list(params) do
    query = from(s in Site,
      join: c in assoc(s, :controllers),
      preload: [controllers: c]
      # group_by: c.id,
      # select: [s]
    )

    Enum.reduce(params, query, fn
      # {:sort, %{sort_by: :controllers, sort_order: sort_order}}, query ->
      #   from q in query, order_by: [{^sort_order, ^sort_by}]
      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        from q in query, order_by: [{^sort_order, ^sort_by}]

      end)
      |> Repo.all()
  end


end
