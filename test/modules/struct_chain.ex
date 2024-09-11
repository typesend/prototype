defmodule StructChain do
  defmodule LevelThree do
    defstruct level: 3

    def level(struct) do
      struct.level
    end

    def level_three_function(struct) do
      struct.level
    end
  end

  defmodule LevelTwo do
    defstruct level: 2
    def __prototype__, do: LevelThree

    def level_two_function(struct) do
      struct.level
    end
  end

  defmodule LevelOne do
    defstruct level: 1
    def __prototype__, do: LevelTwo

    def level_one_function(struct) do
      struct.level
    end
  end
end
