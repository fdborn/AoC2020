defmodule Aoc2020.Day03.Answer do
  def part1 do
    get_input!()
    |> Enum.with_index(0)
    |> Enum.reduce(0, &accumulate_trees(&1, &2, {3, 1}))
  end

  def part2 do
    input =
      get_input!()
      |> Enum.with_index(0)

    a = Enum.reduce(input, 0, &accumulate_trees(&1, &2, {1, 1}))
    b = Enum.reduce(input, 0, &accumulate_trees(&1, &2, {3, 1}))
    c = Enum.reduce(input, 0, &accumulate_trees(&1, &2, {5, 1}))
    d = Enum.reduce(input, 0, &accumulate_trees(&1, &2, {7, 1}))
    e = Enum.reduce(input, 0, &accumulate_trees(&1, &2, {1, 2}))

    [a * b * c * d * e]
  end

  defp accumulate_trees({_, 0}, acc, _), do: acc

  defp accumulate_trees({line, line_index}, trees, {right, down}) do
    char_index = rem(round(line_index / down) * right, length(line))

    case Enum.at(line, char_index) do
      :tree when rem(line_index, down) == 0 -> trees + 1
      _ -> trees
    end
  end

  defp get_input! do
    File.read!("input/day03.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn
      line ->
        line
        |> to_charlist()
        |> Enum.map(fn
          ?. -> :empty
          ?# -> :tree
        end)
    end)
  end
end
