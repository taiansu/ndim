defmodule Ndim.MixProject do
  use Mix.Project

  def project do
    [
      app: :ndim,
      version: "0.1.0",
      elixir: "~> 1.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      keywords: keywords(),
      package: package(),
      deps: deps(),
      name: "ndim",
      source_url: "https://github.com/taiansu/ndim"
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Ndim provides a clean interface for working with n-dimensional nested lists in Elixir."
  end

  defp package do
    [
      files: ~w(lib .formatter.exs mix.exs README* * LICENSE*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/taiansu/ndim"}
    ]
  end

  defp keywords do
    ["nested list", "multidimensional", "functor", "data structure", "list transformation"]
  end
end
