
alias Demo.{
  Controllers.Controller,
  Repo,
  Sites.Site
}

Ecto.Migrator.with_repo(Repo, fn _repo ->

  directory = Application.app_dir(:demo, "priv/repo")

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
          billing_status: item["Billing Status"],
          has_weather_station: has_weather_station
        }

        Repo.insert(site)
      end)
  end



  controllers = fn ->
    filepath = Path.join(directory, "ExampleControllerData.csv")
    File.stream!(filepath)
      |> CSV.decode!(headers: true)
      |> IO.inspect()
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

  sites.()
  controllers.()

end)
