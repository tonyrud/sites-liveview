defmodule Demo.ZipCodes do

  alias Demo.{
    Repo,
    Sites.Site,
    ZipCodes.ZipCode
  }

  def get_zip_codes_in_radius(zip_code, radius_in_miles) do
    query = """
        WITH target AS (SELECT lng_lat_point AS p FROM zip_codes WHERE zip_code = $1::varchar)
        SELECT id, zip_code, city, state, lng_lat_point FROM zip_codes JOIN target ON true
        WHERE ST_DWithin(p::geography, zip_codes.lng_lat_point::geography, $2::double precision)
      """

    args = [zip_code, miles_to_meters(radius_in_miles)]

    case Repo.query(query, args, log: true) do
      {:ok, %Postgrex.Result{columns: cols, rows: rows}}->
        results =
          Enum.map(rows, fn row ->
            Repo.load(ZipCode, {cols, row})
          end)

        {:ok, results}

      _ ->
        {:error, :not_found}
    end
  end

  def get_sites_in_radius_from_zip(zip_code, radius_in_miles) do
    query = """
    WITH zip_point AS (
      SELECT
        lng_lat_point
      from
        zip_codes
      where
        zip_code = $1::varchar)
      SELECT
        s.name,
        s.address,
        ROUND((ST_Distance(s.lng_lat_point::geometry , ST_Transform (zp.lng_lat_point, 4326)::geography ) / 1609.344)::numeric, 2) as distance_in_miles
      from
        sites s
      cross join zip_point zp
      where
        ST_DWithin(s.lng_lat_point::geometry,
        ST_Transform (zp.lng_lat_point, 4326)::geography,
        $2::double precision)
      order by
        distance_in_miles;
    """

    args = [zip_code, miles_to_meters(radius_in_miles)]

    case Repo.query(query, args, log: true) do
      {:ok, %Postgrex.Result{columns: cols, rows: rows}} ->
        results =
          Enum.map(rows, fn row ->
            # convert the decimal selection from query above into float
            row_with_float = List.update_at(row, 2, &Decimal.to_float(&1))

            Repo.load(Site, {cols, row_with_float})
          end)

        {:ok, results}

      _ ->
        {:error, :not_found}
    end
  end

  defp miles_to_meters(miles), do: miles * 1609.344
end
