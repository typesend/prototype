defmodule ModuleApplyTest do
  use ExUnit.Case
  alias DogChain.{Dog, Bulldog, GoldenRetriever}

  setup_all do
    Code.ensure_loaded!(DogChain)
    :ok
  end

  describe "apply/3 for Modules" do
    test "when the module directly exports the function" do
      assert {:ok, "grrr", _meta} = Prototype.apply(Dog, :speak, [])
    end

    test "the function exists in the module chain" do
      assert {:ok, "grrr", _meta} = Prototype.apply(GoldenRetriever, :speak, [])
    end

    test "when no modules export the function" do
      assert {:missing_fun, :drink!, _args, _meta} = Prototype.apply(Bulldog, :drink!, [])
    end
  end
end
