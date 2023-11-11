defmodule Qsmplive.Web.Controller do
  alias Qsmplive.Api.Controller, as: Api

  require Logger
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded]
  )

  plug(:dispatch)

  get "/" do
    Api.get_all_members()
    |> case do
      {:ok, json} ->
        json
        |> Poison.encode()
        |> case do
          {:ok, text} -> send_resp(conn, 200, text)
          {:error, error} -> send_resp(conn, 400, error)
        end

      {:error, err} ->
        send_resp(conn, 400, err)
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
