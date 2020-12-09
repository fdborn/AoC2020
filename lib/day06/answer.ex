defmodule Aoc2020.Day06.Answer do
  def part1 do
    get_input!()
    |> Enum.map(&count_group_answers/1)
    |> Enum.reduce(&Kernel.+/2)
  end

  def part2 do
    get_input!()
    |> Enum.map(&count_correct_group_answers/1)
    |> Enum.reduce(&Kernel.+/2)
  end

  defp count_group_answers(group) do
    group
    |> Enum.join()
    |> to_charlist()
    |> Enum.uniq()
    |> length()
  end

  defp count_correct_group_answers(group) do
    group
    |> Enum.join()
    |> to_charlist()
    |> Enum.group_by(fn char -> char end)
    |> Enum.filter(fn {_, answers} -> length(answers) == length(group) end)
    |> length()
  end

  defp get_input! do
    File.read!("input/day06.txt")
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
  end
end
