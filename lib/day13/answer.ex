defmodule Aoc2020.Day13.Answer do
  def part1() do
    {timestamp, lines} = get_input!()

    {lowest_wait_time, line_number} =
      lines
      |> Enum.filter(&Kernel.!=(&1, :invalid))
      |> Enum.map(fn bus_line ->
        {bus_line - rem(timestamp, bus_line), bus_line}
      end)
      |> Enum.sort()
      |> hd()

    lowest_wait_time * line_number
  end

  def matches_all?(_, []), do: true

  def matches_all?(departure, [{line_number, offset} | rest])
      when rem(departure + offset, line_number) == 0,
      do: matches_all?(departure, rest)

  def matches_all?(_, _), do: false

  def part2() do
    {_, lines} = get_input!()

    {remainder, mod} =
      lines
      |> Enum.with_index()
      |> Enum.filter(&Kernel.!=(elem(&1, 0), :invalid))
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.map(fn {line, offset} ->
        {offset, line}
      end)
      |> reduce_congruent()

    mod - remainder
  end

  # SHOULD work for the test input but doesn't, since its way too slow
  defp reduce_congruent([identity | []]), do: identity

  defp reduce_congruent([{remainder, mod} | rest]) do
    {condition_rem, condition_mod} = reduce_congruent(rest)

    multiplier =
      Stream.iterate(0, &Kernel.+(&1, 1))
      |> Enum.find(fn n ->
        test_remainder = rem(condition_rem + n * condition_mod, mod)
        test_remainder == remainder
      end)

    {condition_rem + multiplier * condition_mod, condition_mod * mod}
  end

  def get_input!() do
    [timestamp, lines_string] =
      File.read!("input/day13.txt")
      |> String.split("\n", trim: true)

    lines =
      lines_string
      |> String.split(",", trim: true)
      |> Enum.map(fn
        "x" -> :invalid
        number -> String.to_integer(number)
      end)

    {String.to_integer(timestamp), lines}
  end
end
