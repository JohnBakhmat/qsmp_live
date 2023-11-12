defmodule Qsmplive.Web.Html do
  require EEx
  require Logger

  @template_dir "#{File.cwd!()}/lib/qsmplive/web/templates/"

  EEx.function_from_file(:def, :root_html, "#{@template_dir}root.html.eex", [
    :inner_content,
    :title
  ])

  def index(title) do
    "Hello, world!"
    |> root_html(title)
  end
end
