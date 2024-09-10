# Prototype

An Elixir library that implements prototype inheritance for dynamic function calling
over a chain of modules. These prototypes can be user-defined struct modules
or any other modules.

## Usage

To specify a module's prototype module, implement the `__prototype__/0` function like so:

```Elixir
defmodule YourModule do
  def __prototype__, do: AnyOtherModule
end
```

Then to call functions wherever they are found up the prototype chain
you might:

```Elixir
case Prototype.apply(YourModule, :function_name, ["argument", "list"]) do
  {:ok, return_value, _meta} -> return_value,
  {:missing_fun, _function_name, _args, _meta} -> {:error, "function not found"}
end
```

Where `_meta` contains tracing metadata about the call chain that executed.
As you might suspect, if the function cannot be found in any of the modules
then the result is a :missing_fun tuple because it's not very fun to have
multiple attempts to call a function fail!

## Installation

This package can be installed by adding `prototype` to
your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:prototype, "~> 1.0.0-alpha"}
  ]
end
```

## Feedback welcome!

If you use this library and have suggestions for how to make it better,
please [file an issue](https://github.com/typesend/prototype/issues).
