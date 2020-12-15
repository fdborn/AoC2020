defmodule Aoc2020.Day12.Answer do
  alias Aoc2020.Day12.Cursor
  alias Aoc2020.Day12.WaypointCursor

  def part1() do
    %Cursor{pos: {pos_x, pos_y}} =
    get_input!()
    |> unroll_turns()
    |> Enum.reduce(%Cursor{}, &Cursor.move(&2, &1))

    abs(pos_x) + abs(pos_y)
  end

  def part2() do
    %WaypointCursor{pos: {pos_x, pos_y}} =
    get_input!()
    |> unroll_turns()
    |> Enum.reduce(%WaypointCursor{}, &WaypointCursor.move(&2, &1))

    abs(pos_x) + abs(pos_y)
  end

  def unroll_turns(movements) do
    movements
    |> Enum.flat_map(&unroll_turn/1)
  end

  defp unroll_turn({direction, degree})
      when direction in [:left, :right] and degree != 90,
      do: [{direction, 90} | unroll_turn({direction, degree - 90})]

  defp unroll_turn(movement), do: [movement]

  def get_input!() do
    File.read!("input/day12.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "N" <> steps -> {:north, String.to_integer(steps)}
      "S" <> steps -> {:south, String.to_integer(steps)}
      "E" <> steps -> {:east, String.to_integer(steps)}
      "W" <> steps -> {:west, String.to_integer(steps)}
      "F" <> steps -> {:forward, String.to_integer(steps)}
      "L" <> degree -> {:left, String.to_integer(degree)}
      "R" <> degree -> {:right, String.to_integer(degree)}
    end)
  end
end
