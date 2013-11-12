defmodule Rinket.Mixfile do
  use Mix.Project

  def project do
    [ app: :rinket,
      version: "0.0.1",
      dynamos: [Rinket.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/rinket/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo, :bcrypt],
      mod: { Rinket, [] } ]
  end

  defp deps do
    [
     { :cowboy, github: "extend/cowboy" },
     { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" },
     { :jsx,    github: "talentdeficit/jsx", tag: "v1.4.3" },
     { :bcrypt, github: "Feuerlabs/erlang-bcrypt" },
     { :gen_smtp, github: "Vagabond/gen_smtp" },
     { :riak_pool,  github: "HashNuke/riak_pool" },
     { :qdate, github: "choptastic/qdate" }
    ]
  end
end
