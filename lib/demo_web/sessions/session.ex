defmodule Demo.Sessions.Session do
  @moduledoc """
  This is the worker process that contains the state for the user's
  active session. When the user's session is terminated, this process
  is also terminated.

  The restart policy for this GenServer is `:transient` so that when a
  `handle_*` callback returns a stop tuple, the `Supervisor` will not
  attempt to restart the process.
  """

  use GenServer, restart: :transient

  alias __MODULE__
  alias Demo.Sessions.Supervisor
  alias Demo.Users

  require Logger

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
  #   Public API
  # ------------------------------

  @doc """
  Start the session GenServer and link it to the
  DynamicSupervisor defined in `Demo.Sessions.Supervisor`.

  Creates a pid based on a via tuple, using the token as the process id.
  """
  def start_link(user) do
    session = Session.new(user)

    GenServer.start_link(__MODULE__, session, name: process_name(session.token))
  end

  @doc """
  Client facing function. This takes the auth params and logs in with `Demo.Users.login/1`
  """
  def create_via_creds(auth_params) do
    case Users.login(auth_params) do
      {:ok, user} ->
        register_session(user)
    end
  end

  def get_session(token) do
    GenServer.call(process_name(token), :fetch_session, @fetch_session_timeout)
  end

  def remove_session(token) do
    GenServer.call(process_name(token), :remove_session, @fetch_session_timeout)
  end

  defp process_name(token), do: {:via, Registry, {SessionRegistry, "sesh:#{token}"}}

  defp register_session(%{"token" => token} = user) do
    case GenServer.whereis(process_name(token)) do
      nil ->
        Supervisor.register(user)
        GenServer.call(process_name(user["token"]), :fetch_session, @fetch_session_timeout)
    end
  end

  # ----------------------------------------
  #   Private GenServer Callback Functions
  # ----------------------------------------

  @impl true
  def init(session) do
    # run handle continue here, if some User session info is not in the initial req
    {:ok, session}
  end

  # @impl true
  # def handle_continue(:fetch_user_details, %Session{token: token, user_id: nil}) do
  #   user = %{
  #     username: "tonyrud",
  #     user_id: "asdfas;dkasfb"
  #   }

  #   session = Session.new(token, user)

  #   {:noreply, session}
  # end

  def new(user) do
    %Session{
      user_id: user["id"],
      username: user["username"],
      token: user["token"]
    }
  end

  @impl true
  def handle_call(:fetch_session, _from, session) do
    {:reply, session, session}
  end

  def handle_call(:remove_session, _from, %Session{token: token} = session) do
    # Logout as side-effect
    # Task.start(fn -> Users.logout(%{token: token}) end)
    Logger.info("Killing session with token: #{token}")

    {:stop, :normal, session, session}
  end
end
