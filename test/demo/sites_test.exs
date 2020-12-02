defmodule Demo.SitesTest do
  use ExUnit.Case

  alias Demo.Sites
  alias Demo.Sites.Site

  test "list_sites/0 should return %Site{}" do
    sites = Sites.list_sites()

    assert %Site{name: "Site 2"} === Enum.at(sites, 1)
  end

  test "list_sites/0 should return 3 items" do
    sites = Sites.list_sites()

    assert length(sites) === 3
  end
end
