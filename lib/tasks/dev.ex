defmodule Mix.Tasks.Dev do
    use Mix.Task

    def run(_) do
        Mix.Task.run("tailwind.build")
        Mix.Task.run("run", ["--no-halt"])
    end
end