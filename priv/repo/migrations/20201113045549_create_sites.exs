defmodule Demo.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:sites) do
      add :name, :string
      add :address, :string
      add :billing_status, :string
      add :has_weather_station, :boolean
    end

    # execute("CREATE TYPE daily_update_status AS ENUM('In Progress', 'In Testing', 'Done');")
    # execute("ALTER TABLE daily_updates ALTER COLUMN status DROP DEFAULT;")
    # execute("
    #   ALTER TABLE daily_updates
    #           ALTER COLUMN status TYPE daily_update_status
    #             USING
    #               CASE status
    #                 WHEN NULL then 'In Progress'
    #                 WHEN 0 then 'In Progress'
    #               end :: daily_update_status;
    # ")
  end

end
