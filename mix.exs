defmodule Firebrick.Mixfile do
  use Mix.Project

  def project do
    [ app: :firebrick,
      version: "0.0.1",
      elixir: "~> 0.14.3",
      deps: deps,
      config_path: "config/#{Mix.env}.exs"
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { Firebrick, [] },
      applications: [:postgrex, :ecto, :phoenix, :bcrypt]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      {:phoenix, "0.3.1"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 0.2.2"},
      {:cowboy, github: "extend/cowboy"},
      {:bcrypt, github: "irccloud/erlang-bcrypt"},
      {:gen_smtp, github: "Vagabond/gen_smtp"},
      {:qdate, github: "choptastic/qdate"},
      {:eiconv, github: "zotonic/eiconv"}
    ]
  end
end
