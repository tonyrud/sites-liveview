defmodule DemoWeb.SitesLive do
  use DemoWeb, :live_view

  alias Demo.Sites

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(
      socket,
      temporary_assigns: [sites: []],
      page_title: "Sites"
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
        sites: Sites.all(sort: sort_options)
      )

    {:noreply, socket}
  end

  defp sort_link(socket, text, sort_by, options) do
    IO.inspect(options, label: "options")
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
