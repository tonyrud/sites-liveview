defmodule Demo.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:sites) do
      add :name, :string
      add :address, :string
      add :billing_status, :string
      add :has_weather_station, :boolean
    end
  end

end
