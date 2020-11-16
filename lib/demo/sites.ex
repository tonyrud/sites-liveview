defmodule Demo.Sites do
  @moduledoc """
  Context module for Sites
  """
  import Ecto.Query

  alias Demo.{
    Repo,
    Sites.Site
  }

  @base_all_query from(s in Site,
    join: c in assoc(s, :controllers),
    group_by: s.id,
    select_merge: %{controllers_count: count(c.site_id)}
  )

  def all do
   Repo.all(@base_all_query)
  end

  def all(params) when is_list(params) do

    Enum.reduce(params, @base_all_query, fn
      {:filter, %{filter: ""}}, query ->
        from q in query, order_by: [{:asc, :id}]

      {:filter, %{filter: filter}}, query ->
        from q in query,
        where: ilike(fragment("concat(?, ?, ?)", q.id, q.name, q.address), ^"%#{filter}%")


      {:sort, %{sort_by: :controllers_count, sort_order: sort_order}}, query ->
        from q in query, order_by: [{^sort_order, :count}]

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        from q in query, order_by: [{^sort_order, ^sort_by}]

      end)
      |> Repo.all()
  end


end
