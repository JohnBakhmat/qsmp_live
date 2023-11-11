defmodule Qsmplive.Web.Router do
    use Plug.Router
    use Plug.ErrorHandler
  
    require Logger
  
    plug(Plug.Logger)
    plug(Plug.Static, at: "/static/", from: {:qsmplive, "public/"})
    plug(:match)
    plug(:dispatch)

    forward("/app", to: Qsmplive.Web.Controller)

    get "/health" do
        send_resp(conn, 200, "ok")
    end

    get "/" do
        conn
        |> put_resp_header("location", "/app/")
        |> send_resp(301, "")
    end

    match _ do
        send_resp(conn, 404, "oops")
    end

    @impl Plug.ErrorHandler
    def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
        Logger.error("kind: #{inspect(kind)}, reason: #{inspect(reason)}, stack: #{inspect(stack)}")
        send_resp(conn, conn.status, "")
    end

end