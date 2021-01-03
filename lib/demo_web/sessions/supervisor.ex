defmodule Demo.Sessions.Supervisor do
  @moduledoc """
  The supervisor is responsible for creating User session state.
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
  def register(token) do
    spec = {Demo.Sessions.Session, token}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
