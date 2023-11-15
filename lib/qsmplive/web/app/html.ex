defmodule Qsmplive.Web.Html do
  require EEx
  require Logger

  @template_dir "#{File.cwd!()}/lib/qsmplive/web/templates/"

  EEx.function_from_file(:def, :root_html, "#{@template_dir}root.html.eex", [
    :inner_content,
    :title
  ])

  EEx.function_from_file(:def, :index_html, "#{@template_dir}index.html.eex", [
    :teams
  ])

  def index(title, teams) do
    teams
    |> Enum.map(fn team ->
      team
      |> Enum.map(fn member ->
        Map.put(
          member,
          "icon",
          member["name"]
          |> String.downcase()
          |> String.replace(" ", "-")
        )
      end)
    end)
    |> index_html()
    |> root_html(title)
  end
end
