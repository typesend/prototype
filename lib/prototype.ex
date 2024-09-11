defmodule Prototype do
  @moduledoc """
  Documentation for `Prototype`.
  """

  @doc """
  Calls functions by searching up a prototype chain of modules, calling it on
  the first module where it is found.
  """
  @spec apply(module | struct, atom, list) :: {:ok, atom, map} | {:missing_fun, atom, list, map}
  def apply(target, name, args) do
    arity = length(args)
    chain = function_chain(target, name, arity)

    result = call(args, chain)

    {:ok, result, %{}}
  rescue
    FunctionClauseError -> {:missing_fun, name, args, %{}}
  end

  @spec call(list, [{module, atom, integer}]) :: any
  def call(args, chain) do
    if chain != [] do
      {m, f, a} = hd(chain)
      arity = length(a)

      try do
        Kernel.apply(m, f, args)
      rescue
        error in FunctionClauseError ->
          # keep going if a matching function clause is not found
          case error do
            %{module: ^m, function: ^f, arity: ^arity} ->
              if tl(chain) != [] do
                call(args, tl(chain))
              else
                raise error
              end
          end
      end
    else
      :whoopsie
    end
  end

  @doc """
  Returns the prototype module for a given module, if one exists.
  """
  @spec has_prototype?(module) :: module | false
  def has_prototype?(m) do
    with true <- function_exported?(m, :__prototype__, 0),
         module when is_atom(module) <- m.__prototype__() do
      module.__info__(:module)
    else
      _no_prototype_found -> false
    end
  end

  @doc """
  Returns whether the given module exports the given function.

  """
  @spec has_function?(module, atom, integer) :: boolean
  def has_function?(module, name, arity) do
    function_exported?(module, name, arity)
  end

  @doc """
  Finds all matching functions up the prototype chain and returns them as a list.

  (Note that a function of the correct arity may be exported by a module,
  but a `FunctionClauseError` would still be raised if there is not a matching
  function *clause* in that module. However, a matching clause may be found up
  further the prototype chain.)
  """
  @spec function_chain(module, atom, integer) :: [function]
  def function_chain(target, name, arity) do
    module = expanded_module_or_struct_module!(target)
    chain = [module] ++ prototype_chain(module)

    Enum.map(chain, fn current_module ->
      if has_function?(current_module, name, arity) do
        {current_module, name, arity}
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  @doc """
  Recursively builds a list of all modules in the prototype chain.
  Works for both modules and structs.
  """
  @spec prototype_chain(module | struct) :: [module]
  def prototype_chain(target) do
    module = expanded_module_or_struct_module!(target)

    if has_prototype?(module) do
      [module.__prototype__() | prototype_chain(module.__prototype__())]
    else
      []
    end
  end

  defp expanded_module_or_struct_module!(target) do
    if is_struct(target) do
      target.__struct__
    else
      Macro.expand_once(target, __ENV__)
    end
  end
end
