defmodule Qsmplive.Api.Controller do
  def get_all_members() do
    with {:ok, body} <- File.read("lib/qsmplive/server/members.json"),
         {:ok, json} <- Poison.decode(body) do
      {:ok, json}
    else
      {:error, error} -> {:error, error}
    end
  end

  def get_online_members(members) do
    members
    |> Enum.map(fn member -> member["twitch"] end)
    |> get_live_status()
  end

  defp get_auth(client_id, client_secret) do
    "https://id.twitch.tv/oauth2/token?client_id=#{client_id}&client_secret=#{client_secret}&grant_type=client_credentials"
    |> HTTPoison.post("{}")
    |> case do
      {:ok, %HTTPoison.Response{body: body}} ->
        body
        |> Poison.decode()
        |> case do
          {:ok, json} -> json |> Map.get("access_token") |> then(&{:ok, &1})
          {:error, error} -> {:error, error}
        end

      {:error, error} ->
        {:error, error}
    end
  end

  defp get_live_status(usernames) do
    client_id = Application.get_env(:qsmplive, :twitch_client_id)
    client_secret = Application.get_env(:qsmplive, :twitch_client_secret)

    with {:ok, token} <- get_auth(client_id, client_secret) do
      query = usernames |> Enum.map(fn x -> "user_login=#{x}" end) |> Enum.join("&")

      "https://api.twitch.tv/helix/streams?#{query}&type=live"
      |> HTTPoison.get([
        {"Client-ID", client_id},
        {"Authorization", "Bearer #{token}"}
      ])
      |> case do
        {:ok, %HTTPoison.Response{body: body}} ->
          body
          |> Poison.decode()
          |> case do
            {:ok, json} -> json |> Map.get("data") |> then(&{:ok, &1})
            {:error, error} -> {:error, error}
          end

        {:error, error} ->
          {:error, error}
      end
      |> case do
        {:ok, data} ->
          {:ok, data |> Enum.map(fn x -> x["user_name"] end)}

        {:error, error} ->
          {:error, error}
      end
    else
      {:error, error} ->
        {:error, error}
    end
  end
end
