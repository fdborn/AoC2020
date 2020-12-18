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

  def part2(input) when is_binary(input), do: part2(get_input!(input))

  def part2(input) do
    {_, lines} = input

    lines
    |> Enum.with_index()
    |> Enum.filter(fn {value, _} -> value != :invalid end)
    |> Enum.sort()
    |> Enum.reverse()
    |> find_valid_sequence()
  end

  def find_valid_sequence([{line_number, offset} | rest]) do
    result =
      Stream.iterate(0, &Kernel.+(&1, line_number))
      |> Enum.find(&matches_all?(&1 - offset, rest))

    result - offset
  end

  def matches_all?(_, []), do: true

  def matches_all?(departure, [{line_number, offset} | rest])
      when rem(departure + offset, line_number) == 0,
      do: matches_all?(departure, rest)

  def matches_all?(_, _), do: false

  def get_input!(input \\ "") do
    """
    0
    17,x,13,19
    """

    """
    1337
    1789,37,47,1889
    """

    """
    939
    7,13,x,x,59,x,31,19
    """

    [timestamp, lines_string] =
    "1\n" <> input
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
