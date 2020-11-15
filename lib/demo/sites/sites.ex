defmodule Demo.Sites do
  # import Ecto.Query

  alias Demo.{
    Repo,
    Site,
  }

  def all do
    Site
    |> Repo.all()
    |> Repo.preload(:controllers)
  end
end
