defmodule Mix.Tasks.Dev do
    use Mix.Task

    def run(_) do
        Mix.Task.run("tailwind.build")
    end
end