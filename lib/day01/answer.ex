defmodule Aoc2020.Day01.Answer do
  @magic_number 2020

  def part1 do
    get_input()
    |> find_sum(@magic_number, 2)
    |> Enum.reduce(&Kernel.*/2)
  end

  def part2 do
    get_input()
    |> find_sum(@magic_number, 3)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp get_input do
    {:ok, content} = File.read("input/day01.txt")

    content
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  defp find_sum(input, target, 1) do
    Enum.find(input, :no_result, fn number -> number == target end)
  end

  defp find_sum(input, target, depth) do
    Enum.reduce_while(input, :no_result, fn number, _acc ->
      case find_sum(input, target - number, depth - 1) do
        :no_result ->
          {:cont, :no_result}

        result when is_list(result) ->
          if Enum.member?(result, number) do
            {:cont, :no_result}
          else
            {:halt, [number] ++ result}
          end

        result when result != number ->
          {:halt, [number, result]}

        _ ->
          {:cont, :no_result}
      end
    end)
  end
end
