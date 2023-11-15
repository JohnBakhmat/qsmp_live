defmodule Qsmplive.Web.Controller do
  alias Qsmplive.Api.Controller, as: Api
  alias Qsmplive.Web.Html, as: View
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
      channels_one_or_more = member["twitch"]

      channels =
        if is_list(channels_one_or_more) do
          channels_one_or_more
        else
          [channels_one_or_more]
        end

      {is_live, channel} =
        Enum.find(channels, fn x -> String.downcase(x) in lowercase_online end)
        |> case do
          nil -> {false, List.first(channels)}
          channel -> {true, channel}
        end

      member
      |> Map.put("is_live", is_live)
      |> Map.put("twitch", channel)
    end)
  end

  get "/" do
    {status, resp} =
      with {:ok, all_members} <- Api.get_all_members(),
           {:ok, online_members} <- Api.get_online_members(all_members) do
        members =
          merge_members(all_members, online_members)
          |> Enum.sort_by(&{&1["team"], !&1["is_live"], &1["name"]})

        teams = Enum.chunk_by(members, & &1["team"]) |> Enum.to_list()

        page = View.index("QSMPLive", teams)
        {200, page}
      else
        {:error, error} ->
          Logger.error("Error: #{inspect(error)}")
          {500, "oops"}
      end

    send_resp(conn, status, resp)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
