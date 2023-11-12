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
    {status, resp} =
      with {:ok, all_members} <- Api.get_all_members(),
           {:ok, online_members} <- Api.get_online_members(all_members) do


        {200, %{
          "all_members" => all_members,
          "online_members" => online_members
        }}
      else
        {:error, error} ->
          Logger.error("Error: #{inspect(error)}")
          {500, "oops"}
      end

    send_resp(conn, status, Poison.encode!(resp))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
