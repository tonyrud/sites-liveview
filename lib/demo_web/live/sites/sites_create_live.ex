defmodule DemoWeb.SitesCreateLive do
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       page_title: "Create Site",
       alert: false
     )}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Create Site</h1>
    """
  end
end
