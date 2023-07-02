defmodule Demo.ZipCodes do
  @moduledoc """
  `Demo.ZipCodes.ZipCode` context module
  """

  alias Demo.Repo
  alias Demo.Sites.Site
  alias Demo.ZipCodes.ZipCode

  @type sites_or_error :: {:ok, [Site]} | {:error, Exception.t()}

  @miles_meters 1609.344

  @spec target_cte(atom()) :: String.t()
  defp target_cte(:sites) do
    "WITH target AS (SELECT lng_lat_point FROM sites WHERE id = $1::numeric)"
  end

  defp target_cte(:zipcodes) do
    "WITH target AS (SELECT lng_lat_point FROM zip_codes WHERE zip_code = $1::varchar)"
  end

  @spec base_geo_query() :: String.t()
  defp base_geo_query do
    """
    SELECT
        s.id,
        s.name,
        s.address,
        ROUND((ST_Distance(s.lng_lat_point::geometry, ST_Transform(t.lng_lat_point, 4326)::geography) / 1609.344)::numeric, 2) as distance_in_miles
      FROM
        sites s
      CROSS JOIN target t
      WHERE
        ST_DWithin(s.lng_lat_point::geometry,
        ST_Transform (t.lng_lat_point, 4326)::geography,
        $2::double precision)
      ORDER BY
        distance_in_miles;
    """
  end

  @doc """
  Returns a list of all `Demo.ZipCodes.ZipCode`
  """
  @spec list_zip_codes() :: [ZipCode] | nil
  def list_zip_codes do
    Repo.all(ZipCode)
  end

  @doc """
  Returns a list of `Demo.Sites.Site`, filtered by distance in miles from the found zip code.
  """
  @spec get_sites_in_radius_from_zip(String.t(), integer()) :: sites_or_error()
  def get_sites_in_radius_from_zip(zip_code, radius_in_miles) do
    query = """
    #{target_cte(:zipcodes)}

    #{base_geo_query()}
    """

    args = [zip_code, miles_to_meters(radius_in_miles)]

    run_query(query, args)
  end

  @doc """
  Returns a list of `Demo.Sites.Site`, filtered by distance in miles from the found site.
  """
  @spec get_sites_in_radius_from_site(binary(), integer()) :: sites_or_error()
  def get_sites_in_radius_from_site(site_id, radius_in_miles) do
    site_id = String.to_integer(site_id)

    query = """
      #{target_cte(:sites)}

      #{base_geo_query()}
    """

    args = [site_id, miles_to_meters(radius_in_miles)]

    run_query(query, args)
  end

  @spec run_query(Ecto.Queryable.t(), list()) :: sites_or_error()
  defp run_query(query, args) do
    case Repo.query(query, args, log: true) do
      {:ok, %Postgrex.Result{columns: cols, rows: rows}} ->
        results = Enum.map(rows, &load_site(&1, cols))

        {:ok, results}

      {:error, _} = error ->
        error
    end
  end

  @spec load_site(list(), list()) :: Site.t()
  defp load_site(row, columns) do
    # convert the decimal selection from query above into float
    # row_with_float = List.update_at(row, 3, &Decimal.to_float(&1))
    distance_in_miles =
      row
      |> Enum.at(3)
      |> Decimal.to_float()

    # TODO: does not load virtual `distance_in_miles` column
    site = Repo.load(Site, {columns, row})

    %Site{site | distance_in_miles: distance_in_miles}
  end

  @spec miles_to_meters(binary() | number()) :: float()
  defp miles_to_meters(miles) when is_binary(miles) do
    miles_integer =
      case miles do
        "" -> 0
        miles -> String.to_integer(miles)
      end

    miles_integer * @miles_meters
  end

  defp miles_to_meters(miles), do: miles * @miles_meters
end
