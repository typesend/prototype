defmodule StructApplyTest do
  use ExUnit.Case
  require IEx
  alias StructChain.{LevelOne, LevelTwo, LevelThree}

  setup_all do
    Code.ensure_all_loaded!([LevelOne, LevelTwo, LevelThree])
    :ok
  end

  describe "apply/3 for Structs" do
    test "when the struct directly exports the function" do
      assert {:ok, 1, _meta} = Prototype.apply(%LevelOne{}, :level_one_function, [])
    end

    test "the function exists in the struct chain" do
      assert {:ok, 2, _meta} = Prototype.apply(%LevelTwo{}, :level_two_function, [])
    end

    test "when no structs export the function" do
      assert {:missing_fun, :level_fifty_function, [%LevelOne{level: 1}], _meta} =
               Prototype.apply(%LevelOne{}, :level_fifty_function, [])
    end

    test "dynamically calling a struct field-getter function" do
      assert {:ok, 1, _meta} = Prototype.apply(%LevelOne{}, :level, [])
      assert {:ok, 2, _meta} = Prototype.apply(%LevelTwo{}, :level, [])
      assert {:ok, 3, _meta} = Prototype.apply(%LevelThree{}, :level, [])
    end
  end
end
