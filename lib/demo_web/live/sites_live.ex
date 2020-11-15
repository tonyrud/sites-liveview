defmodule DemoWeb.SitesLive do
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do

    # sites = Enum.map(sites, fn site ->
    #   %{
    #     name: site.name,
    #     count: length(site.controllers)
    #   }
    # end)

    {:ok, assign(socket, sites: Demo.Sites.all())}
  end

end
