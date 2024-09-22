defmodule DemoWeb.HomeLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do

    {:ok,
     assign(
       socket,
       page_title: "Home",
       alert: false,
       repo_config: Demo.Repo.config() |> Keyword.take([:adapter, :database, :hostname, :port, :username])
     )}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1 class="mb-4 text-4xl font-extrabold leading-none tracking-tight text-gray-700 md:text-5xl lg:text-6xl dark:text-white">Repo</h1>
    <p class="mb-6 text-lg font-normal text-gray-600 lg:text-2xl dark:text-gray-400"><%= inspect(@repo_config) %></p>
    """
  end
end
