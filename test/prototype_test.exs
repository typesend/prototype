defmodule PrototypeTest do
  use ExUnit.Case
  doctest Prototype

  setup_all do
    Code.ensure_all_loaded!([ProtoModule, NonProtoModule])
    :ok
  end

  describe "has_prototype?/1" do
    test "when a prototype has been specified" do
      assert Enum == Prototype.has_prototype?(ProtoModule)
    end

    test "when no prototype specified" do
      refute Prototype.has_prototype?(NonProtoModule)
      assert function_exported?(NonProtoModule, :normal_function, 0)
    end
  end
end
