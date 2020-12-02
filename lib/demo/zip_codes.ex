defmodule Demo.ZipCodes do

  alias Demo.{
    Sites.Site,
    ZipCodes.ZipCode
  }

  @repo Application.get_env(:demo, :repo)

  @miles_meters 1609.344

  defp sites_target_cte() do
    "WITH target AS (SELECT lng_lat_point FROM sites WHERE id = $1::numeric)"
  end

  defp zipcode_target_cte() do
    "WITH target AS (SELECT lng_lat_point FROM zip_codes WHERE zip_code = $1::varchar)"
  end

  defp base_geo_query() do
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

  def list_zip_codes do
    @repo.all(ZipCode)
  end

  def get_sites_in_radius_from_zip(zip_code, radius_in_miles) do
    query = """
      #{zipcode_target_cte()}

      #{base_geo_query()}
    """

    args = [zip_code, miles_to_meters(radius_in_miles)]

    run_query(query, args)
  end

  def get_sites_in_radius_from_site(site_id, radius_in_miles) do
    site_id = String.to_integer(site_id)

    query = """
      #{sites_target_cte()}

      #{base_geo_query()}
    """

    args = [site_id, miles_to_meters(radius_in_miles)]

    run_query(query, args)
  end

  defp run_query(query, args) do
    case @repo.query(query, args, log: true) do
      {:ok, %Postgrex.Result{columns: cols, rows: rows}} ->
        results = Enum.map(rows, &load_site(&1, cols))

        {:ok, results}

      error ->
        {:error, error}
    end
  end

  defp load_site(row, columns) do
      # convert the decimal selection from query above into float
      # row_with_float = List.update_at(row, 3, &Decimal.to_float(&1))
      distance_in_miles =
        row
        |> Enum.at(3)
        |> Decimal.to_float()

      # TODO: does not load virtual `distance_in_miles` column
      site = @repo.load(Site, {columns, row})

      %Site{site | distance_in_miles: distance_in_miles}
  end

  defp miles_to_meters(miles) when is_binary(miles) do
    miles_integer = case miles do
      "" -> 0
      miles -> String.to_integer(miles)
    end

    miles_integer * @miles_meters
  end
  defp miles_to_meters(miles), do: miles * @miles_meters
end
