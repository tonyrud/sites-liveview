defmodule Demo.Repo.Migrations.AddLatLongToSites do
  use Ecto.Migration

  def change do
    execute("SELECT AddGeometryColumn ('sites','lng_lat_point',4326,'POINT',2);")

    execute("CREATE INDEX sites_geom_idx ON sites USING GIST (lng_lat_point);")
  end
end
