defmodule Demo.SessionsTest do
  use ExUnit.Case, async: false

  alias Demo.Sessions.{
    Session,
    Supervisor
  }

  setup do
    start_supervised!({Supervisor, %{name: :test}})
    :ok
  end

  test "create_via_creds/1 creates sessions bases on token" do
    Session.create_via_creds(%{username: "abc", password: "123"})
    Session.create_via_creds(%{username: "asdfa", password: "wat"})

    assert 2 = count_children()
  end

  test "get_session/1 gets session with token" do
    auth_params = %{
      username: "abc",
      password: "1234"
    }

    session_state = Session.create_via_creds(auth_params)

    assert Session.get_session(session_state.token) == session_state
  end

  test "remove_session/1 removes session via token" do
    auth_params = %{
      username: "abc",
      password: "1234"
    }

    %{token: token} = Session.create_via_creds(auth_params)

    assert 1 = count_children()

    Session.remove_session(token)

    assert 0 = count_children()
  end

  defp count_children do
    length(Supervisor.children())
  end
end
