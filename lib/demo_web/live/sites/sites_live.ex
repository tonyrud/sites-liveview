defmodule DemoWeb.SitesLive do
  @moduledoc """
  LV module for Sites page
  """
  use DemoWeb, :live_view

  alias Demo.Sites

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Sites.subscribe()

    {:ok,
     assign(
       socket,
       temporary_assigns: [sites: []],
       page_title: "Sites",
       selected_sites: [],
       modal: false,
       alert: false
     )}
  end

  # Handle route path changes.
  @impl true
  def handle_params(params, _url, socket) do
    sort_by = String.to_atom(params["sort_by"] || "id")
    sort_order = String.to_atom(params["sort_order"] || "asc")

    sort_options = %{sort_by: sort_by, sort_order: sort_order}

    socket =
      assign(socket,
        options: sort_options,
        sites: Sites.list_sites(sort: sort_options)
      )

    {:noreply, socket}
  end

  # Handle input filtering for sites
  @impl true
  def handle_event("filter", %{"filter" => filter}, socket) do
    params = [filter: %{filter: filter}]

    new_sites = Sites.list_sites(params)

    socket =
      update(
        socket,
        :sites,
        fn _sites -> new_sites end
      )

    {:noreply, socket}
  end

  def handle_event("close_modal", _, socket) do
    socket =
      assign(
        socket,
        modal: false
      )

    {:noreply, socket}
  end

  def handle_event("row_clicked", %{"id" => id}, socket) do
    {:noreply,
     push_redirect(socket,
       to:
         Routes.live_path(
           socket,
           DemoWeb.SiteLive,
           id
         )
     )}
  end

  # Handles the click events for editing. Receives the %Site{} id and selects if it's not currently select,
  # and deselects if it is.
  # The id will be a string in html, and needs to be converted to an integer for correct comparison.
  @impl true
  def handle_event("check", %{"id" => selected_id}, socket) do
    %{assigns: %{selected_sites: selected_sites, sites: sites}} = socket

    selected_id = String.to_integer(selected_id)

    # find the selected site to edit
    site =
      Enum.find(sites, fn item ->
        item.id === selected_id
      end)

    checked_ids = Enum.map(selected_sites, & &1.id)

    # remove site if it's already in the selected sites list
    selected_sites =
      if selected_id in checked_ids do
        Enum.filter(selected_sites, &(&1.id != selected_id))
      else
        selected_sites ++ [site]
      end

    socket =
      assign(
        socket,
        selected_sites: selected_sites
      )

    {:noreply, socket}
  end

  def handle_event("edit", _, socket) do
    # open modal here
    socket =
      assign(
        socket,
        modal: true
      )

    {:noreply, socket}
  end

  def handle_event("save_edits", form, socket) do
    # iterate over selected sites, and update
    Enum.each(form, fn {id, changes} ->
      id = String.to_integer(id)

      Sites.update_site(id, changes)
    end)

    socket =
      assign(
        socket,
        modal: false
      )

    {:noreply, socket}
  end

  # Handles a broadcast to PubSub module.
  @impl true
  def handle_info({:site_updated, updated_site}, socket) do
    # close flash after count
    Process.send_after(self(), :clear_flash, 2000)

    # get updated sites by current sort params
    new_sites = Sites.list_sites(sort: socket.assigns.options)

    socket =
      socket
      |> update(
        :sites,
        fn _sites -> new_sites end
      )
      |> put_flash(:info, "#{updated_site.name} updated")
      |> assign(alert: true)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:clear_flash, socket) do
    {:noreply, assign(socket, alert: false)}
  end

  defp change_weather_text(true), do: "Yes"
  defp change_weather_text(false), do: "No"

  defp sort_link(socket, text, sort_by, options) do
    text =
      if sort_by == options.sort_by do
        "#{text} #{arrow_direction(options.sort_order)}"
      else
        text
      end

    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          sort_by: sort_by,
          sort_order: toggle_sort_order(options.sort_order)
        )
    )
  end

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc

  defp arrow_direction(:asc), do: "↓"
  defp arrow_direction(:desc), do: "↑"

  defp selected_billing_status(%{billing_status: billing_status}, option_name) do
    option_name = String.to_atom(option_name)

    if billing_status == option_name do
      "selected"
    end
  end

  @spec selected_billing_status(map, binary) :: nil | binary
  defp selected_has_weather_station(%{has_weather_station: has_weather_station}, option_name) do
    if has_weather_station == option_name do
      "selected"
    end

    true
  end

  defp format_date(date) do
    Calendar.strftime(date, "%a, %b %d %Y")
  end
end
