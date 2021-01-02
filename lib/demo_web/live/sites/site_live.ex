defmodule DemoWeb.SiteLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Demo.Sites

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, site} = Sites.get_site(id)

    {:ok,
     assign(
       socket,
       site: site,
       alert: false
     )}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1><%= @site.name %></h1>

    <h2> Controllers </h2>
    <table class="table-auto">
    <thead>
      <tr>
        <th class="px-4 py-2">Controller ID</th>
        <th class="px-4 py-2">Name</th>
        <th class="px-4 py-2">Type</th>
        <th class="px-4 py-2">Mode</th>
      </tr>
    </thead>
    <tbody>
    <%= for c <- @site.controllers do %>
      <tr>
        <td class="border px-5 py-4"><%= c.id %></td>
        <td class="border px-5 py-4"><%= c.name %></td>
        <td class="border px-5 py-4"><%= c.type %></td>
        <td class="border px-5 py-4"><%= c.mode %></td>
      </tr>
    <% end %>
    </tbody>
    </table>
    """
  end
end
