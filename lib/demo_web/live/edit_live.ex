defmodule DemoWeb.EditLive do
  use DemoWeb, :live_view

  alias Demo.Sites

  @impl true
  def mount(params, session, socket) do
    IO.inspect(socket, label: "SOCKET")
    {:ok, assign(
      socket,
      temporary_assigns: [sites: []],
      page_title: "Sites Edit",
      checked: []

      )}
    end

    @impl true
    def handle_params(params, _url, socket) do

    {:noreply, socket}
  end

end
