defmodule Demo.TestRepo do
  alias Ecto.Changeset
  alias Demo.Sites.Site
  alias Demo.ZipCodes.ZipCode

  def all(%Ecto.Query{from: %{source: {_, Site}}}) do
    [
      %Site{
        name: "Site 1"
      },
      %Site{
        name: "Site 2"
      },
      %Site{
        name: "Site 3"
      }
    ]
  end

  def all(ZipCode) do
    [
      %ZipCode{
        zip_code: "10154"
      },
      %ZipCode{
        zip_code: "20154"
      }
    ]
  end

  def one(%Ecto.Query{from: %{source: {_, Site}}}) do
    %Site{
      name: "Test name"
    }
  end

  def one(_query), do: nil

  def update!(%Changeset{errors: [], changes: values}) do
    {:ok, struct(Site, values)}
  end

  def update!(changeset) do
    {:error, changeset}
  end

  def insert!(%Changeset{errors: [], changes: values}) do
    {:ok, struct(Site, values)}
  end

  def insert!(changeset) do
    {:error, changeset}
  end

  def transaction(_fn) do
    {:ok,
     %Site{
       name: "Test name"
     }}
  end
end
