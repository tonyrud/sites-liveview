defmodule Demo.Sites do
  @moduledoc """
  Context module for Sites
  """
  import Ecto.Query

  alias Demo.{
    Repo,
    Sites.Site,
  }

  def all do
    Site
    |> Repo.all()
    |> Repo.preload(:controllers)
  end

  def all(params) when is_list(params) do
    query = from(s in Site)

    Enum.reduce(params, query, fn
      {:name, ""}, query ->
        query

      {:name, name}, query ->
        from q in query, where: q.name == ^name

    end)
    |> Repo.all()
  end
end
