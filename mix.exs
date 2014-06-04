defmodule Firebrick.Mixfile do
  use Mix.Project

  def project do
    [ app: :firebrick,
      version: "0.0.1",
      elixir: "~> 0.13.2",
      deps: deps,
      config_path: "config/#{Mix.env}.exs"
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { Firebrick, [] },
      applications: [:postgrex, :ecto, :phoenix]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      {:phoenix, "0.2.4"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 0.2.0"},
      {:jazz, github: "meh/jazz", ref: "7af3b74e58eb1a3fc6b9874a2077efa420f6dfcc"},
      {:cowboy, github: "extend/cowboy", override: true, ref: "05024529679d1d0203b8dcd6e2932cc2a526d370"},
      {:bcrypt, github: "irccloud/erlang-bcrypt"},
      {:gen_smtp, github: "Vagabond/gen_smtp"},
      {:qdate, github: "choptastic/qdate"},
      {:eiconv, github: "zotonic/eiconv"}
    ]
  end
end
