defmodule Qsmplive.Api.Controller do

    def get_all_members() do
        with {:ok, body} <- File.read("lib/qsmplive/server/members.json"),
            {:ok, json} <- Poison.decode(body) do
            {:ok, json}
        else
            {:error, error} -> {:error, error}
        end
    end
end 