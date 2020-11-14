defmodule Demo.Sites do
  # import Ecto.Query

  alias Demo.{
    Repo,
    Site,
  }

  def all do
    result =
    Site
    |> Repo.all()
    |> Repo.preload(:controllers)

    {:ok, result}
  end
end
