defmodule Qsmplive.Api.Endpoint do
  use GenServer
  alias Qsmplive.Api.Controller, as: Controller

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_all_members do
    GenServer.call(__MODULE__, :get_all_members)
  end

  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_call(:get_all_member, _from, state) do
    case Controller.get_all_members() do
      {:ok, json} -> {:reply, {:ok, json}, state}
      {:error, error} -> {:reply, {:error, error}, state}
    end
  end
end
