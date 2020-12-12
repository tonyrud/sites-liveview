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
       alert: false,
       options: %{
         zipcodes: zipcode_options(),
         site_ids: site_options()
       }
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do

    distance = params["distance"] || "0"
    search_type = params["search_type"] || "zip_code"
    site_id = params["site_id"]
    zip_code = params["zip_code"]

    form_model = %{
      "distance" => distance,
      "search_type" => search_type,
      "site_id" => site_id,
      "zip_code" => zip_code
    }

    {:ok, sites_in_radius} =
      case search_type do
        "zip_code" -> ZipCodes.get_sites_in_radius_from_zip(zip_code, distance)
        "site" -> ZipCodes.get_sites_in_radius_from_site(site_id, distance)
        nil -> {:ok, []}
      end

    socket =
      assign(socket,
        sites: sites_in_radius,
        form_model: form_model
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("form_changed", params, socket) do
    socket = push_param(socket, Map.delete(params, "_target"))

    {:noreply, socket}
  end

  defp push_param(socket, new_params) do
    new_params = Map.merge(socket.assigns.form_model, new_params)

    form_deleted_keys =
      if Map.get(new_params, "search_type") === "site" do
        site_id =
          new_params["site_id"] || Enum.at(socket.assigns.options.site_ids, 0) |> Map.get(:value)

        new_params
        |> Map.delete("zip_code")
        |> Map.put("site_id", site_id)
      else
        zip =
          new_params["zip_code"] || Enum.at(socket.assigns.options.zipcodes, 0) |> Map.get(:value)

        new_params
        |> Map.delete("site_id")
        |> Map.put("zip_code", zip)
      end

    updated_params =
      form_deleted_keys
      |> Map.to_list()
      # remove nil values
      |> Enum.filter(fn {_, v} -> !is_nil(v) end)
      # remove empty string values
      |> Enum.filter(fn {_, v} -> is_binary(v) && String.length(v) !== 0 end)

    push_patch(socket,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          updated_params
        )
    )
  end

  defp search_types() do
    [%{value: "zip_code", name: "Zip Code"}, %{value: "site", name: "Site ID"}]
  end

  defp site_options() do
    [sort: %{sort_by: :id, sort_order: :asc}]
    |> Sites.list_sites()
    |> Enum.map(fn site ->
      %{value: "#{site.id}", name: "#{site.id} - #{site.name}"}
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
      if is_number(option_name) && !is_number(current_selection) do
        String.to_integer(current_selection)
      else
        current_selection
      end

    if current_selection == option_name, do: "selected"
  end
end
