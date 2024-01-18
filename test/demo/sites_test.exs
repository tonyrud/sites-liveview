defmodule Demo.SitesTest do
  use Demo.DataCase

  alias Demo.Sites
  alias Ecto.Changeset

  describe "list_sites/0" do
    test "list_sites/0 should return 3 items" do
      make_many(3, :site)
      sites = Sites.list_sites()

      assert length(sites) === 3
    end
  end

  describe "create_site/1" do
    test "should return invalid changeset if empty params" do
      assert {:error, %Changeset{valid?: false}} = Sites.create_site(%{})
    end

    test "create a %Site{}" do
      point = %Geo.Point{coordinates: {34.55, -25.32}, srid: 4326}

      params = %{
        address: "test address",
        billing_status: :paid,
        has_weather_station: false,
        name: "test name",
        lng_lat_point: point
      }

      {:ok, site} = Sites.create_site(params)

      assert site.name == "test name"
      assert site.address == "test address"
      assert site.billing_status == :paid
      assert site.has_weather_station == false
      assert site.lng_lat_point == point
    end
  end

  describe "get_site/1" do
    test "returns correct %Site{}" do
      site = make(:site)

      {:ok, queried_site} = Sites.get_site(site.id)
      assert site.id == queried_site.id
    end

    test "returns not found error" do
      assert Sites.get_site("1234") == {:error, :not_found}
    end
  end

  describe "delete_site/1" do
    test "deletes correct %Site{}" do
      site = 3 |> make_many(:site) |> Enum.at(1)

      {:ok, deleted_site} = Sites.delete_site(site.id)

      sites = Sites.list_sites()

      assert length(sites) == 2
      assert deleted_site not in sites
    end

    test "returns not found error" do
      assert Sites.delete_site("1234") == {:error, :not_found}
    end
  end

  describe "update_site/2" do
    test "updates correct %Site{}" do
      site = 3 |> make_many(:site) |> Enum.at(1)

      point = %Geo.Point{coordinates: {50, -50}, srid: 4326}

      update_params = %{
        address: "updated address",
        billing_status: :paid,
        has_weather_station: false,
        name: "updated name",
        lng_lat_point: point
      }

      {:ok, site} = Sites.update_site(site.id, update_params)

      assert site.name == "updated name"
      assert site.address == "updated address"
      assert site.billing_status == :paid
      assert site.has_weather_station == false
      assert site.lng_lat_point == point
    end

    test "returns error struct on bad geo coords" do
      site = make(:site)

      update_params = %{
        "latitude" => "160",
        "longitude" => "-500"
      }

      {:error, %Changeset{errors: errors}} = Sites.update_site(site.id, update_params)

      assert length(errors) == 2
    end
  end

  # describe("broadcast/2") do
  #   test "adds event to PubSub", stuff do
  #     site = make_many(3, :site) |> Enum.at(1)

  #     update_params = %{
  #       name: "updated name"
  #     }

  #     {:ok, site} = Sites.update_site(site.id, update_params)

  #     # Sites.subscribe() |> IO.inspect()
  #   end
  # end
end
