defmodule Tensor.Helper do

  # LISTS

  @doc """
  Swaps the element at position `pos_a` with the element at position `pos_b` inside a list.

  TODO: Move to a separate module with helper functions.

  # Examples

    iex> swap_elems_in_list([1,2,3,4,5], 1, 3)
    [1, 4, 3, 2, 5]
  """
  def swap_elems_in_list(list, pos_a, pos_b) do
    a = Enum.fetch!(list, pos_a)
    b = Enum.fetch!(list, pos_b)
    
    list
    |> List.replace_at(pos_a, b)
    |> List.replace_at(pos_b, a)
  end

  def swap2(list, pos_a, pos_a), do: list 
  def swap2(list, pos_a, pos_b) when pos_a < pos_b do
    {initial, rest} = Enum.split(list, pos_a)
    {between, tail} = Enum.split(rest, pos_b - pos_a)
    a = hd(between)
    b = hd(tail)
    initial ++ [b] ++ tl(between) ++ [a] ++ tl(tail)
  end

  def swap2(list, pos_a, pos_b) when pos_b < pos_a, do: swap2(list, pos_b, pos_a)

  def map_swap(list, pos_a, pos_b) do
    map = for {v, i} <- (list |> Enum.with_index), into: %{}, do: {i, v}
    a = map[pos_a]
    map
    |> put_in([pos_a], map[pos_b])
    |> put_in([pos_b], a)
    |> Map.values
  end

  def map_swap_2(list, pos_a, pos_b) do
    map = 
      list
      |> list_to_indexed_map
    a = map[pos_a]
    map
    |> put_in([pos_a], map[pos_b])
    |> put_in([pos_b], a)
    |> Map.values
  end

  def list_to_indexed_map(list) do
    do_list_to_indexed_map(list, 0, %{})
  end

  def do_list_to_indexed_map([], index, acc_map) do
    acc_map
  end

  def do_list_to_indexed_map([head | tail], index, acc_map) do
    do_list_to_indexed_map(tail, index+1, Map.put(acc_map, index, head))
  end

  # MAPS

  @doc """
  Puts `val` under `map` inside a nested map indicated with `keys`.
  This is required, as the normal `put_in` will fail if one of the levels
  indicated by `keys` is not initialized to a map yet.

  TODO: Move to a separate module with helper functions.

  ## Examples:

    iex>put_in_path(%{}, [1,2,3], 4)
    %{1 => %{2 => %{3 => 4}}}
  """
  def put_in_path(map, keys, val) do
    do_put_in_path(map, keys, val, [])
  end

  defp do_put_in_path(map, [key], val, acc) do
    new_acc = acc ++ [key]
    put_in(map, new_acc, val)
  end

  defp do_put_in_path(map, [key | keys], val, acc) do
    new_acc = acc ++ [key]
    new_map = put_in(map, new_acc, get_in(map, new_acc) || %{})
    do_put_in_path(new_map, keys, val, new_acc)
  end
end