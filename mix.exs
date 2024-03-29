defmodule Demo.MixProject do
  use Mix.Project

  def project do
    [
      app: :demo,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer(),
      xref: [exclude: [Phoenix.Ecto.CheckRepoStatus]],

      # Docs
      name: "Demo Sites",
      source_url: "https://github.com/tonyrud/sites-liveview",
      homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      preferred_cli_env: [
        ci: :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Demo.Application, []},
      extra_applications: [:logger, :runtime_tools, :observer, :wx]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:csv, "~> 2.4"},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.6"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:ex_doc, "~> 0.22.0", only: :dev, runtime: false},
      {:faker, "~> 0.13", only: [:dev, :test]},
      {:floki, ">= 0.27.0", only: :test},
      {:geo_postgis, "~> 3.1"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:observer_cli, "~> 1.5"},
      {:phoenix, "~> 1.7.0"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.18.18"},
      {:phoenix_live_dashboard, "~> 0.7.2"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_view, "~> 2.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 0.5"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:styler, "~> 0.11", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      ci: ["lint", "test", "dialyzer"],
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate"] ++ seed_db(Mix.env()),
      "ecto.reset": ["ecto.drop --force-drop", "ecto.setup"],
      "ecto.seed": ["run priv/repo/seeds/seeds.exs"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      lint: [
        "compile --warnings-as-errors",
        "format --check-formatted",
        "credo"
      ],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end

  defp seed_db(:dev), do: ["ecto.seed"]
  defp seed_db(_), do: []

  defp dialyzer do
    [
      plt_add_apps: [:mix, :ex_unit],
      plt_core_path: "_build",
      plt_file: {:no_warn, "_build/dialyzer.plt"}
    ]
  end
end
