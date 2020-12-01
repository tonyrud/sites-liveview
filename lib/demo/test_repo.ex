defmodule Demo.TestRepo do
  # alias Ecto.Changeset
  alias Demo.Sites.Site
  alias Demo.ZipCodes.ZipCode

  def all(%Ecto.Query{from: %{source: {_, Demo.Sites.Site}}}) do
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
end
