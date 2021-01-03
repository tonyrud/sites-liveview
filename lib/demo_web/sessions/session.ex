defmodule GatewayWeb.Sessions.Session do
  @moduledoc """
  This is the worker process that contains the state for the user's
  active session. When the user's session is terminated, this process
  is also terminated.

  The restart policy for this GenServer is `:transient` so that when a
  `handle_*` callback returns a stop tuple, the `Supervisor` will not
  attempt to restart the process.
  """

  use GenServer, restart: :transient

  require Logger

  alias __MODULE__

  alias Demo.Sessions.Supervisor

  @fetch_session_timeout 60_000

  @typedoc """
  The session struct contains all the information required for the application to
  manage user sessions without having to reach out to an external service.

  `token` - The full JWT token associated with the session from AWS Cognito
  `user_id` - The ID of the user currently attached to the session
  `username` - The username the person logged in with
  """

  @type t :: %Session{
          token: String.t() | nil,
          user_id: integer() | nil,
          username: String.t() | nil
        }

  defstruct ~w(token user_id username)a

  # ------------------------------
  #   Public GenServer Interface
  # ------------------------------

  @doc """
  Start the session GenServer and link it to the
  DynamicSupervisor defined in `GatewayWeb.Sessions.Supervisor`.
  """
  def start_link(token) do
    session = %Session{token: token}

    GenServer.start_link(__MODULE__, session)
  end

  def create_via_token(token) do
    {:ok, pid} = Supervisor.register(token)

    # GenServer.call(pid, :fetch_session, @fetch_session_timeout)
    # case Users.login(params) do
    #   {:ok, %{"token" => token}} ->
    #     create_via_token(token)

    #   error ->
    #     error
    # end
    # create_via_token(params.token)
  end

  # ----------------------------------------
  #   Private GenServer Callback Functions
  # ----------------------------------------

  @impl true
  def init(session) do
    {:ok, session, {:continue, :fetch_user_details}}
  end

  def handle_call({:set_token, token}, _from, session) do
    new_session = %{session | token: token}

    {:reply, new_session, new_session}
  end

  def handle_call(:destroy_session, _from, %Session{token: token} = session) do
    # Logout as side-effect, previously we were ignoring the return value, but still blocking
    # Task.start(fn -> Users.logout(%{token: token}) end)
    Logger.info("Killing session with token: #{token}")

    {:stop, :normal, session, session}
  end
end
