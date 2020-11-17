defmodule DemoWeb.SitesLive do
  use DemoWeb, :live_view

  alias Demo.Sites

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       temporary_assigns: [sites: []],
       page_title: "Sites",
       checked: []
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    sort_by = (params["sort_by"] || "id") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    sort_options = %{sort_by: sort_by, sort_order: sort_order}

    socket =
      assign(socket,
        options: sort_options,
        sites: Sites.list_sites(sort: sort_options)
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("filter", %{"filter" => filter}, socket) do
    params = [filter: %{filter: filter}]

    socket = assign(socket, params ++ [sites: Sites.list_sites(params)])
    {:noreply, socket}
  end

  @impl true
  def handle_event("check", %{"value" => id}, socket) do
    checked =
      if Enum.member?(socket.assigns.checked, id) do
        Enum.filter(socket.assigns.checked, &(&1 != id))
      else
        socket.assigns.checked ++ [id]
      end

    socket = assign(socket, checked: checked)
    {:noreply, socket}
  end

  def handle_event("edit", _, socket) do
    {:noreply, push_redirect(socket, to: "/sites/edit")}
  end

  def handle_event(_event, _, socket) do
    {:noreply, socket}
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
end
