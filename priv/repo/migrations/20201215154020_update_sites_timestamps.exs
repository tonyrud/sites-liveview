defmodule Demo.Repo.Migrations.UpdateSitesTimestamps do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      modify :name, :string, null: false
      modify :address, :string, null: false

      timestamps(default: fragment("NOW()"))
    end
  end
end
