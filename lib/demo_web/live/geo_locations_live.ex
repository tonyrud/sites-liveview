defmodule DemoWeb.GeoLocationsLive do
  use DemoWeb, :live_view

  alias Demo.{
    Sites,
    ZipCodes
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       temporary_assigns: [sites: []],
       page_title: "Sites | Location Search",
       sites: []
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    IO.inspect(params, label: "PARAMS")
    distance = params["distance"]
    search_type = params["search_type"]
    site_id = params["site_id"]

    form_model = %{
      distance: distance,
      search_type: search_type,
      site_id: site_id
    }

    {:ok, sites_in_radius} =
      case search_type do
        "zip-code" -> ZipCodes.get_sites_in_radius_from_zip("46805", distance)
        "site" -> ZipCodes.get_sites_in_radius_from_site(site_id, distance)
      end

    socket =
      assign(socket,
        sites: sites_in_radius,
        form_model: form_model
      )

    {:noreply, socket}
  end


  @impl true
  def handle_event("form_changed", %{"distance" => distance, "search-type" => search_type, "site-id" => site_id}, socket) do

    socket =
    push_patch(socket,
      to:
      Routes.live_path(
        socket,
        __MODULE__,
        distance: distance,
        search_type: search_type,
        site_id: site_id
      )
    )

      {:noreply, socket}
    end

  @impl true
  def handle_event("form_changed", stuff, socket) do
    IO.inspect(stuff, label: "WAT")
    {:noreply, assign(socket, sites: []) }
  end

  defp search_types() do
    [%{value: "zip-code", name: "Zip Code"}, %{value: "site", name: "Site"}]
  end

  defp site_options() do
    [sort: %{sort_by: :id, sort_order: :asc}]
      |> Sites.list_sites()
      |> Enum.map(fn site ->
        %{value: site.id, name: "#{site.id} - #{site.name}"}
      end)
  end

  defp zipcode_options() do
      ZipCodes.list_zip_codes()
      |> Enum.map(fn zip ->
        %{value: zip.zip_code, name: "#{zip.zip_code} - #{zip.city}"}
      end)
  end

  defp selected_option(current_selection, option_name) do
    current_selection =
      if is_number(option_name) do
        String.to_integer(current_selection)
      else
        current_selection
      end

    if current_selection == option_name, do: "selected"
  end

end
