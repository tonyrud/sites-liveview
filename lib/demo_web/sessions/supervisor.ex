defmodule Demo.Sessions.Supervisor do
  @moduledoc """
  The supervisor is responsible for creating and storing a User's session state.
  """

  use DynamicSupervisor

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Registers a new worker, and creates the worker process
  """
  def register(user) do
    spec = {Demo.Sessions.Session, user}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @doc """
  Removes a session from the supervision tree
  """
  def remove_session(session_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, session_pid)
  end

  @doc """
  Utility method to check which processes are under supervision
  """
  def children do
    DynamicSupervisor.which_children(__MODULE__)
  end
end
