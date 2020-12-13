defmodule Aoc2020.Day09.Answer do
  @preamble_length 25

  def part1 do
    input = get_input!()

    input
    |> Enum.with_index()
    |> Enum.drop(@preamble_length)
    |> Enum.filter(fn {value, index} ->
      input
      |> get_preamble(@preamble_length, index)
      |> find_sum(value, 2)
      |> case do
        nil -> true
        _ -> false
      end
    end)
    |> List.first()
    |> elem(0)
  end

  def part2 do
    {min, max} =
      get_input!()
      |> find_consecutive_summands(part1())
      |> Enum.min_max()

    min + max
  end

  def get_preamble(sequence, length, offset) do
    sequence
    |> Enum.drop(offset - length)
    |> Enum.take(length)
  end

  def find_sum(sequence, target, 1) do
    case Enum.find(sequence, fn number -> number == target end) do
      nil -> nil
      result -> [result]
    end
  end

  def find_sum(sequence, target, summand_count) do
    Enum.find_value(sequence, fn number ->
      with result when is_list(result) <- find_sum(sequence, target - number, summand_count - 1),
           false <- Enum.member?(result, number) do
        [number | result]
      else
        _ -> nil
      end
    end)
  end

  def find_consecutive_summands(sequence, target) do
    sequence
    |> Enum.with_index()
    |> Enum.map(fn {_, index} ->
      sequence
      |> Enum.drop(index)
      |> find_summands(target)
    end)
    |> Enum.filter(fn
      [] -> false
      _ -> true
    end)
    |> List.first()
  end

  def find_summands([], _), do: []
  def find_summands([head | _], target) when head > target, do: []
  def find_summands([head | _], target) when head == target, do: [head]
  def find_summands([_ | []], _), do: []

  def find_summands([head | tail], target) do
    case find_summands(tail, target - head) do
      [] -> []
      result -> [head | result]
    end
  end

  def get_input! do
    File.read!("input/day09.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end
