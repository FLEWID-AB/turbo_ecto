defmodule Turbo.Ecto.Builder.OrderBy do
  @moduledoc false

  alias Ecto.Query.Builder.OrderBy

  @doc """
  Builds a quoted order_by expression.
  """
  @spec build(Macro.t(), [Macro.t()], [Macro.t()]) :: Macro.t()
  def build(query, sorts, binding) do
    query = query
    |> Macro.escape()

    IO.puts("\nQUERY: #{inspect(query, limit: :infinity)}\n")
    IO.puts("\nBINDING: #{inspect(binding, limit: :infinity)}\n")

    expr = Enum.map(sorts, &expr/1)
    op = :prepend
    env = __ENV__

    IO.puts("\nEXPR: #{inspect(expr, limit: :infinity)}\n")
    IO.puts("\nOP: #{inspect(op, limit: :infinity)}\n")
    IO.puts("\nENV: #{inspect(env, limit: :infinity)}\n")
    
    query
    |> OrderBy.build(binding, expr, op, env)
    |> Code.eval_quoted()
    |> elem(0)
  end

  # [
  #   asc: {:field, [], [{:query, [], Elixir}, :updated_at]},
  #   desc: {:field, [], [{:query, [], Elixir}, :inserted_at]}
  # ]
  defp expr(%{direction: direction, attribute: %{name: name, parent: parent}}) do
    parent = Macro.var(parent, Elixir)
    quote do: {unquote(direction), field(unquote(parent), unquote(name))}
  end
end
