defmodule Demo.Repo.Migrations.AddPostgisData do
  use Ecto.Migration

  def change do

    execute("CREATE EXTENSION IF NOT EXISTS postgis")

    create_if_not_exists table(:zip_codes) do
      add :zip_code, :string, size: 5, null: false
      add :city, :string, null: false
      add :state, :string, size: 2, null: false

    end

    # Add a field `lng_lat_point` with type `geometry(Point,4326)`.
    # This can store a "standard GPS" (epsg4326) coordinate pair {longitude,latitude}.
    execute("SELECT AddGeometryColumn ('zip_codes','lng_lat_point',4326,'POINT',2);")

    # Syntax - CREATE INDEX [indexname] ON [tablename] USING GIST ( [geometryfield] );
    execute("CREATE INDEX zip_codes_geom_idx ON zip_codes USING GIST (lng_lat_point);")
  end
end
