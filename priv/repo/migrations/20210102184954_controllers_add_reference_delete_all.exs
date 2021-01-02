defmodule Demo.Repo.Migrations.ControllersAddReferenceDeleteAll do
  use Ecto.Migration

  def change do
    drop(constraint(:controllers, "controllers_site_id_fkey"))

    alter table(:controllers) do
      modify :site_id, references(:sites, on_delete: :delete_all)
    end
  end
end
