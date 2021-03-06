defmodule Firebrick.Mixfile do
  use Mix.Project

  def project do
    [app: :firebrick,
     version: "0.0.2",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod: {Firebrick, []},
      applications: app_list(Mix.env)
     ]
  end

  defp app_list do
    [:comeonin, :phoenix, :phoenix_html, :gen_smtp, :cowboy, :logger, :phoenix_ecto, :postgrex]
  end

  defp app_list(:dev),  do: [:phoenix_live_reload | app_list]
  defp app_list(:test), do: [:hound | app_list]
  defp app_list(_),     do: app_list


  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:phoenix, "~> 1.0.3"},
      {:phoenix_ecto, "~> 1.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.1"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:cowboy, "~> 1.0"},
      {:comeonin, "~> 1.6"},
      {:gen_smtp, github: "Vagabond/gen_smtp"},
      {:hound, "~> 0.7", only: :test},
      {:faker, "~> 0.6", only: :test}
    ]
  end
end
