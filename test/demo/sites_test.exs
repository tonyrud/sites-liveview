defmodule Demo.SitesTest do
  use Demo.DataCase

  alias Demo.{
    Sites
  }

  test "list_sites/0 should return 3 items" do
    make_many(3, :site)
    sites = Sites.list_sites()

    assert length(sites) === 3
  end
end
