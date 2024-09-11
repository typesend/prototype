defmodule Prototype.MixProject do
  use Mix.Project

  def project do
    [
      app: :prototype,
      version: "0.8.0-alpha",
      package: package(),
      description: """
      A work-in-progress Elixir library that implements prototype inheritance for dynamic
      function calling over a chain of modules. These prototypes can be
      user-defined struct modules or any other modules.
      """,
      source_url: "https://github.com/typesend/prototype",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      # docs
      name: "Prototype",
      docs: [
        main: "Prototype",
        extras: ["README.md"]
      ]
    ]
  end

  def package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/typesend/prototype"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:mix_test_interactive, "~> 3.2", only: :dev, runtime: false}
    ]
  end

  def elixirc_paths(:test), do: ["lib", "test/modules"]
  def elixirc_paths(_), do: ["lib"]
end
