defmodule Aoc2020.Day02.Answer do
  def part1 do
    get_input!()
    |> Enum.filter(&test_char_limit/1)
    |> Enum.count()
  end

  def part2 do
    get_input!()
    |> Enum.filter(&test_char_positions/1)
    |> Enum.count()
  end

  defp get_input! do
    File.read!("input/day02.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&format_line/1)
  end

  defp format_line(line) do
    [lower, upper, letter, password] =
      Regex.run(~r/(\d+)-(\d+)\s(.):\s(.+)/, line, capture: :all_but_first)

    [char | _] = to_charlist(letter)
    [String.to_integer(lower), String.to_integer(upper), char, password]
  end

  defp test_char_limit([lower, upper, letter, password]) do
    hit_count =
      password
      |> to_charlist()
      |> Enum.filter(fn char -> char == letter end)
      |> Enum.count()

    hit_count >= lower && hit_count <= upper
  end

  defp test_char_positions([first, second, letter, password]) do
    chars = to_charlist(password)
    first_hit = Enum.at(chars, first - 1) == letter
    second_hit = Enum.at(chars, second - 1) == letter

    (first_hit || second_hit) && !(first_hit && second_hit)
  end
end
