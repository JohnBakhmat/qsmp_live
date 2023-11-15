defmodule Mix.Tasks.Tailwind.Build do
  use Mix.Task

  def run(_) do
    Mix.shell().cmd("npx tailwindcss -i tailwind.in.css -o priv/styles.css")
  end
end

defmodule Mix.Tasks.Tailwind.Dev do
  use Mix.Task

  def run(_) do
    Mix.shell().cmd("npx tailwindcss -i tailwind.in.css -o priv/styles.css --watch")
  end
end
