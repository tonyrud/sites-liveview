defmodule DemoWeb.SitesCreateLive do
  use DemoWeb, :live_view

  alias Demo.{
    Sites.Site,
    Sites
  }

  @impl true
  def mount(_params, _session, socket) do
    changeset = Site.create_changeset(%Site{})

    {:ok,
     assign(
       socket,
       changeset: changeset,
       page_title: "Create Site",
       alert: false
     )}
  end

  @impl true
  def handle_event("save", %{"site" => form_params}, socket) do
    IO.inspect(form_params, label: "FORM")

    case Sites.create_site(form_params) do
      {:ok, _site} ->
        changeset = Site.create_changeset(%Site{})

        socket = assign(socket, changeset: changeset)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
  end
end
