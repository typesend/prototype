defmodule DogChain do
  defmodule Dog do
    def speak, do: "grrr"
  end

  defmodule GoldenRetriever do
    def __prototype__, do: Dog
  end

  defmodule Bulldog do
    def __prototype__, do: Dog
    def speak, do: "Woof! Woof!"
  end
end
