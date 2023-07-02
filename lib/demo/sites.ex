defmodule Demo.Sites do
  @moduledoc """
  Context module for `Demo.Sites.Site`
  """
  import Ecto.Query

  @sites_subscription_channel inspect(__MODULE__)

  alias Demo.Repo
  alias Demo.Sites.Site

  @base_list_query from(s in Site,
                     left_join: c in assoc(s, :controllers),
                     group_by: s.id,
                     select_merge: %{
                       controllers_count: fragment("count(?) as post_count", c.site_id)
                     }
                   )

  @doc """
  Create a new `Demo.Sites.Site`.
  """
  @spec create_site(map()) :: {:ok, Site.t()} | {:error, Ecto.Changeset.t()}
  def create_site(attributes) do
    %Site{}
    |> Site.create_changeset(attributes)
    |> Repo.insert()
  end

  def list_sites do
    Repo.all(@base_list_query)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Demo.PubSub, @sites_subscription_channel)
  end

  @doc """
  Returns a list of sites matching the given `params`.

  Example params:

  [
   sort: %{sort_by: :item, sort_order: :asc}
  ]
  """
  def list_sites(params) when is_list(params) do
    params
    |> Enum.reduce(@base_list_query, fn
      {:filter, %{filter: ""}}, query ->
        from q in query, order_by: [{:asc, :id}]

      {:filter, %{filter: filter}}, query ->
        from q in query,
          where: ilike(fragment("concat(?, ?, ?)", q.id, q.name, q.address), ^"%#{filter}%")

      {:sort, %{sort_by: :controllers_count, sort_order: sort_order}}, query ->
        from q in query, order_by: [{^sort_order, fragment("post_count")}]

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        from q in query, order_by: [{^sort_order, ^sort_by}]
    end)
    |> Repo.all()
  end

  def get_site(site_id) do
    query =
      from site in Site,
        where: site.id == ^site_id,
        preload: [:controllers]

    case Repo.one(query) do
      %Site{} = site ->
        {:ok, site}

      nil ->
        {:error, :not_found}
    end
  end

  def delete_site(site_id) do
    Site
    |> Repo.get(site_id)
    |> case do
      %Site{} = site ->
        Repo.delete(site)

      nil ->
        {:error, :not_found}
    end
  end

  def update_site(site_id, params) do
    {_transaction_result, update_result} =
      Repo.transaction(fn ->
        case get_site(site_id) do
          {:ok, %Site{} = site} ->
            site
            |> Site.update_changeset(params)
            |> Repo.update()

          {:error, _reason} = error ->
            error
        end
      end)

    broadcast(update_result, :site_updated)

    update_result
  end

  def broadcast(updated_site, event) do
    Phoenix.PubSub.broadcast(
      Demo.PubSub,
      @sites_subscription_channel,
      {event, updated_site}
    )
  end
end
