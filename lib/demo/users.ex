defmodule Demo.Users do
  @moduledoc """
  Users management via AWS Cognito
  """

  def login(params) do
    # return mock aws object
    mocked_user = %{
      "id" => "b24aa8b1-218d-454f-a99f-62c552c15a38",
      "username" => params.username,
      "token" => "#{params.password}-asdfa234234nblb3k234"
    }

    {:ok, mocked_user}
  end
end
