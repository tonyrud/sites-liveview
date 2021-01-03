defmodule DemoWeb.SitesCreateLive do
  @moduledoc """
  LiveView logic for creating new `Demo.Sites.Site`
  """

  use DemoWeb, :live_view

  alias Demo.{
    Sites,
    Sites.Site
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
  @doc """
  Form submit handler. Passes all form inputs to `Demo.Sites.create_site/1`
  to run the business logic for creating a new `Demo.Sites.Site`
  """
  def handle_event("save", %{"site" => form_params}, socket) do
    case Sites.create_site(form_params) do
      {:ok, _site} ->
        {:noreply,
         push_redirect(socket,
           to:
             Routes.live_path(
               socket,
               DemoWeb.SitesLive
             )
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
  end
end
