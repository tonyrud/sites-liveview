alias Demo.{
  Controllers.Controller,
  Repo,
  Sites.Site,
  ZipCodes.ZipCode
}

Ecto.Migrator.with_repo(Repo, fn _repo ->
  directory = Application.app_dir(:demo, "priv/repo/seeds")

  sites = fn ->
    filepath = Path.join(directory, "ExampleSitesData.csv")

    File.stream!(filepath)
    |> CSV.decode!(headers: true)
    |> Enum.each(fn item ->
      has_weather_station = String.equivalent?(item["Has Weather Station Installed?"], "TRUE")

      site = %Site{
        id: String.to_integer(item["Site ID"]),
        name: item["Site Name"],
        address: item["Address"],
        billing_status: item["Billing Status"] |> String.downcase() |> String.to_atom(),
        has_weather_station: has_weather_station,
        lng_lat_point: %Geo.Point{coordinates: {item["Long"], item["Lat"]}, srid: 4326}
      }

      Repo.insert(site)
    end)
  end

  controllers = fn ->
    filepath = Path.join(directory, "ExampleControllerData.csv")

    File.stream!(filepath)
    |> CSV.decode!(headers: true)
    |> Enum.each(fn item ->
      controller = %Controller{
        id: String.to_integer(item["Controller ID"]),
        name: item["Name"],
        mode: item["Mode"],
        site_id: String.to_integer(item["Site ID"]),
        type: item["Type"]
      }

      Repo.insert(controller)
    end)
  end

  zip_codes = fn ->
    filepath = Path.join(directory, "zip_codes.csv")

    File.stream!(filepath)
    |> CSV.decode!(headers: true)
    |> Enum.each(fn item ->
      %{"City" => city, "Zip Code" => zip, "State" => state, "Lat" => lat, "Long" => long} = item

      city = String.downcase(city)
      state = String.downcase(state)

      attrs = %{
        zip_code: zip,
        city: city,
        state: state,
        lng_lat_point: %Geo.Point{coordinates: {long, lat}, srid: 4326}
      }

      changeset = ZipCode.create_changeset(%ZipCode{}, attrs)

      Repo.insert(changeset)
    end)
  end

  sites.()
  controllers.()
  zip_codes.()
end)
