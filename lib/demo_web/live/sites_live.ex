defmodule DemoWeb.SitesLive do
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, sites} = Demo.Sites.all()
    sites = Enum.map(sites, fn site ->
      %{
        name: site.name,
        count: length(site.controllers)
      }
    end)

    {:ok, assign(socket, sites: sites)}
  end

end
