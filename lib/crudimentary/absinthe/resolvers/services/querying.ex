defmodule CRUDimentary.Absinthe.Resolvers.Services.Querying do
  @moduledoc false

  import Ecto.Query

  def scope_module(_schema, policy) do
    if function_exported?(policy, :scope, 3) do
      policy
    else
      nil
    end
  end

  def scope(schema, current_account, parent, policy) do
    scope_module = scope_module(schema, policy)

    if scope_module do
      scope_module.scope(schema, current_account, parent)
    else
      schema
    end
  end

  def filter(queryable, filters, mapping \\ %{}, custom_filters \\ %{}) do
    CRUDimentary.Ecto.Filter.call(
      queryable,
      filters,
      mapping,
      custom_filters
    )
  end

  def sort(queryable, sortings) do
    sorting = sort_list(sortings)
    order_by(queryable, ^sorting)
  end

  def sort_list(sortings) do
    Enum.map(sortings || [], fn {key, direction} ->
      {
        String.to_atom("#{direction}"),
        String.to_atom("#{key}")
      }
    end) ++ [desc: :inserted_at]
  end
end
