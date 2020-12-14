defmodule Aoc2020.Day10.Answer do
  def part1 do
    %{1 => distance_one, 3 => distance_three} =
      get_input!()
      |> Enum.sort()
      |> Enum.reduce({%{}, 0}, fn joltage, {distances, last} ->
        {Map.update(distances, joltage - last, 1, &Kernel.+(&1, 1)), joltage}
      end)
      |> elem(0)

    distance_one * (distance_three + 1)
  end

  def part2 do
    input =
      get_input!()
      |> Enum.sort()

    offsets =
      input
      |> Enum.map_reduce(0, fn joltage, last ->
        {joltage - last, joltage}
      end)
      |> elem(0)

    segment_lengths =
      offsets
      |> Enum.flat_map_reduce([], fn
        1, [] -> {[], [1]}
        1, [head | _] -> {[], [head + 1]}
        3, acc -> {acc, []}
      end)
      |> (fn
            {list, last_acc} -> list ++ last_acc
          end).()

    segment_lengths
    |> Enum.reduce(1, fn number, acc -> possible_permutations(number) * acc end)
  end

  def possible_permutations(0), do: 1
  def possible_permutations(n), do: n - 1 + possible_permutations(n - 1)

  def get_input! do
    File.read!("input/day10.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end
