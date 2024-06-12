defmodule TestingEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :testing_ecto,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # the application should include all the files in the test directory when compiling in the test environment as well as those in the lib directory
  defp elixirc_paths(:test), do: ["lib", "test"]
  # only the lib directory will be available in other environments(:dev, :prod)
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TestingEcto.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ecto, "~> 3.1"},
      {:faker, "~> 0.18.0", only: [:test, :dev]}
    ]
  end
end
