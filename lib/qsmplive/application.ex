defmodule Qsmplive.Application do
  use Application

  @impl true
  def start(_type, _args) do
    port = Application.get_env(:qsmplive, :port)

    children = [
      {Bandit, scheme: :http, plug: Qsmplive.Web.Router, port: port},
      {Qsmplive.Api.Endpoint, nil}
    ]

    opts = [strategy: :one_for_one, name: Qsmplive.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
