defmodule Prototype do
  @moduledoc """
  Documentation for `Prototype`.
  """
  def apply(m, f, a) when is_atom(m) do
    lookup_and_apply(m, f, a)
  rescue
    FunctionClauseError -> lookup_and_apply(m, :missing_fun, [f, a])
  end

  def apply(s, f, a) when is_struct(s) do
    m = s.__struct__
    args = [s | a]
    lookup_and_apply(m, f, args)
  rescue
    FunctionClauseError -> lookup_and_apply(s.__struct__, :missing_fun, [f, a])
  end

  def has_prototype?(m) do
    with true <- function_exported?(m, :__prototype__, 0),
         module when is_atom(module) <- Kernel.apply(m, :__prototype__, []),
         prototype_module <- module.__info__(:module) do
      prototype_module
    else
      _no_prototype_found -> false
    end
  end

  def lookup_and_apply(m, f, a, modules_searched \\ []) do
    with prototype <- has_prototype?(m),
         found_immediately? <- function_exported?(m, f, length(a)) do
      if found_immediately? do
        try do
          Kernel.apply(m, f, a)
        rescue
          FunctionClauseError ->
            if prototype do
              searched = [prototype | modules_searched]
              lookup_and_apply(prototype, f, a, searched)
            else
              raise FunctionClauseError, module: m, function: f, arity: length(a)
            end

          error ->
            raise RuntimeError, "Unexpected error: #{IO.inspect(error)}"
        end
      else
        if prototype do
          searched = [prototype | modules_searched]
          lookup_and_apply(prototype, f, a, searched)
        else
          raise FunctionClauseError, module: m, function: f, arity: length(a)
        end
      end
    end
  end
end
