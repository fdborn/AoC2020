defmodule Aoc2020.Day05.Answer do
  @row_upper_boundary 127
  @column_upper_boundary 7

  def part1 do
    get_input!()
    |> Enum.map(fn [row, column] -> get_row(row) * 8 + get_column(column) end)
    |> Enum.sort()
    |> List.last()
  end

  def part2 do
    boarding_passes =
      get_input!()
      |> Enum.map(fn [row, column] -> [get_row(row), get_column(column)] end)
      |> Enum.into(%{}, fn [row, column] -> {row * 8 + column, {row, column}} end)

    missing_ids =
      for row_index <- 0..@row_upper_boundary,
          column_index <- 0..@column_upper_boundary,
          id = row_index * 8 + column_index,
          !Map.has_key?(boarding_passes, id),
          do: id

    Enum.find(missing_ids, nil, fn id ->
      Map.has_key?(boarding_passes, id - 1) && Map.has_key?(boarding_passes, id + 1)
    end)
  end

  defp get_row(instructions) do
    approx_index(0..@row_upper_boundary, instructions, {:front, :back})
  end

  defp get_column(instructions) do
    approx_index(0..@column_upper_boundary, instructions, {:left, :right})
  end

  defp approx_index([result], _, _), do: result
  defp approx_index(_, [], _), do: :no_result

  defp approx_index(range, [instruction | rest], {lowerInstruction, upperInstruction} = rules) do
    [lower, upper] = Enum.chunk_every(range, trunc(Enum.count(range) / 2))

    new_range =
      case instruction do
        ^lowerInstruction -> lower
        ^upperInstruction -> upper
      end

    approx_index(new_range, rest, rules)
  end

  defp get_input! do
    File.read!("input/day05.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn
      line ->
        line
        |> to_charlist()
        |> Enum.map(fn
          ?F -> :front
          ?B -> :back
          ?L -> :left
          ?R -> :right
        end)
        |> Enum.chunk_every(7)
    end)
  end
end
