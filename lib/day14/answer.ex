defmodule Aoc2020.Day14.Answer do
  alias Aoc2020.Day14.MemoryMask

  def get_input() do
    File.read!("input/day14.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "mask = " <> mask ->
        {:mask, parse_mask(mask)}

      "mem" <> _ = line ->
        [address, value] = Regex.run(~r/(\d+).+=\s(\d+)$/, line, capture: :all_but_first)
        {:memory, String.to_integer(address), String.to_integer(value)}
    end)
  end

  def parse_mask(mask) do
    mask
    |> String.split("", trim: true)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn
      {"X", offset} -> {:x_bit, offset}
      {value, offset} -> {String.to_integer(value), offset}
    end)
  end

  def part1() do
    get_input()
    |> Enum.reduce({%{}, nil}, fn
      {:mask, mask_items}, {memory, _} ->
        {memory, mask_items}

      {:memory, address, value}, {memory, mask_items} ->
        new_memory = Map.put(memory, address, apply_masks(value, mask_items))
        {new_memory, mask_items}
    end)
    |> elem(0)
    |> Map.values()
    |> Enum.reduce(0, &Kernel.+/2)
  end

  def apply_masks(number, mask_items) do
    mask_items
    |> Enum.filter(&Kernel.!=(elem(&1, 0), :x_bit))
    |> Enum.reduce(number, &apply_mask(&2, &1))
  end

  def apply_mask(number, {1, bit_offset}) do
    use Bitwise
    1 <<< bit_offset ||| number
  end

  def apply_mask(number, {0, bit_offset}) do
    use Bitwise
    ~~~trunc(:math.pow(2, bit_offset)) &&& number
  end

  def part2() do
    get_input()
    |> Enum.reduce({%{}, nil}, fn
      {:mask, mask_items}, {memory, _} ->
        {memory, mask_items}

      {:memory, address, value}, {memory, mask_items} ->
        new_memory =
          %MemoryMask{elements: mask_items}
          |> MemoryMask.apply(address)
          |> Enum.reduce(memory, &Map.put(&2, &1, value))

        {new_memory, mask_items}
    end)
    |> elem(0)
    |> Map.values()
    |> Enum.reduce(0, &Kernel.+/2)
  end
end
