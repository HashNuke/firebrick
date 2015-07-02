defmodule Mix.Tasks.Phoenix.Release do
  use Mix.Task

  @shortdoc "Creates a release using exrm"

  def run(args) do
    Application.put_env(:phoenix, :serve_endpoints, true, persistent: true)
    Mix.Task.run "release", args
  end
end
