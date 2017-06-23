defmodule Adrestia.Mixfile do
  use Mix.Project

  def project do
    [app: :adrestia,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger],
     mod: {Adrestia, []}]
  end

  defp deps do
    [{:cachex, "~> 2.1"},
     {:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.0"},
     {:httpotion, "~> 3.0.2"}]
  end
end
