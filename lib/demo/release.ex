defmodule Demo.Release do
  @moduledoc """
  Release tasks for migrations and seeds.
  """

  require Logger

  @app :demo

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  @doc """
  Seed seeds file for repo.
  """
  def seed(repo, filename) do
    load_app()

    case Ecto.Migrator.with_repo(repo, &eval_seed(&1, filename)) do
      {:ok, {:ok, _fun_return}, _apps} ->
        :ok

      {:ok, {:error, reason}, _apps} ->
        Logger.error(reason)
        {:error, reason}

      {:error, term} ->
        IO.warn(term, [])
        {:error, term}
    end
  end

  defp eval_seed(repo, filename) do
    seeds_file = get_path(repo, "seeds", filename)

    if File.regular?(seeds_file) do
      {:ok, Code.eval_file(seeds_file)}
    else
      {:error, "Seeds file not found."}
    end
  end

  defp get_path(repo, directory, filename) do
    priv_dir = "#{:code.priv_dir(@app)}"

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    Path.join([priv_dir, repo_underscore, directory, filename])
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
