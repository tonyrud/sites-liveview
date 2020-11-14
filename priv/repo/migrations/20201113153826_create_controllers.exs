defmodule Demo.Repo.Migrations.CreateControllers do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:controllers) do
      add :name, :string
      add :mode, :string
      add :type, :string

      add :site_id, references("sites")
    end
  end
end
