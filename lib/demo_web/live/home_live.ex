defmodule DemoWeb.HomeLive do
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       page_title: "Home"
     )}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1>No content</h1>
    """
  end
end
