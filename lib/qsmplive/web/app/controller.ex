defmodule Qsmplive.Web.Controller do
  alias Qsmplive.Api.Controller, as: Api

  require Logger
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded]
  )

  plug(:dispatch)

  defp merge_members(all, online) do
    lowercase_online = Enum.map(online, fn x -> String.downcase(x) end)

    Enum.map(all, fn member ->
      channel = member["twitch"]

      # The channel can be string or list of strings 
      is_online =
        if is_list(channel) do
          Enum.any?(channel, fn x -> String.downcase(x) in lowercase_online end)
        else
          String.downcase(channel) in lowercase_online
        end

      Map.put(member, "is_live", is_online) |> dbg()
    end)
  end

  get "/" do
    {status, resp} =
      with {:ok, all_members} <- Api.get_all_members(),
           {:ok, online_members} <- Api.get_online_members(all_members) do
        members = merge_members(all_members, online_members) 
          |> Enum.sort_by(&{&1["is_live"], &1["team"], &1["name"]}, :desc)

        {200, members}
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
