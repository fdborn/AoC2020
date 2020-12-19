defmodule Aoc2020.Day14.MemoryMask do
  alias Aoc2020.Day14.MemoryMask
  use Bitwise

  defstruct elements: []

  def apply(%MemoryMask{elements: elements}, address) do
    %{simple: simple, floating: floating} =
      elements
      |> Enum.group_by(fn
        {:x_bit, _} -> :floating
        _ -> :simple
      end)

    address =
      simple
      |> Enum.reduce(address, &apply_simple/2)

    unfold_floating(floating, address)
  end

  defp apply_simple({0, _}, address), do: address
  defp apply_simple({1, offset}, address), do: set_bit(address, offset)

  defp set_bit(value, offset), do: 1 <<< offset ||| value
  defp unset_bit(value, offset), do: ~~~trunc(:math.pow(2, offset)) &&& value

  defp unfold_floating(elements, address) when is_integer(address),
    do: unfold_floating(elements, [address])

  defp unfold_floating([{_, offset}], addresses) do
    addresses
    |> Enum.flat_map(fn address ->
      [unset_bit(address, offset), set_bit(address, offset)]
    end)
  end

  defp unfold_floating([{_, offset} | rest], addresses) do
    unfold_floating(rest, addresses)
    |> Enum.flat_map(fn address ->
      [unset_bit(address, offset), set_bit(address, offset)]
    end)
  end
end
