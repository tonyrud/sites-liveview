defmodule Demo.SitesTest do
  use ExUnit.Case
  # use Demo.DataCase
  # import Demo.Test.Fixtures

  alias Demo.{
    Sites,
    Sites.Site
  }

  test "list_sites/0 should return %Site{}" do
    sites = Sites.list_sites()

    assert %Site{name: "Site 2"} === Enum.at(sites, 1)
  end

  test "list_sites/0 should return 3 items" do
    make_many(4, :sites)
    sites = Sites.list_sites()

    assert length(sites) === 3
  end
end
