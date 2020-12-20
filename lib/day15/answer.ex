defmodule Aoc2020.Day15.Answer do
  alias Aoc2020.Day15.Game

  def get_input() do
    "1,20,8,12,0,14"
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1() do
    %{prev: prev} =
      get_input()
      |> Enum.reduce(%Game{}, &Game.add_starter(&2, &1))
      |> run_until(2021)

    prev
  end

  def run_until(%{timestamp: t} = game, timestamp) when t >= timestamp, do: game
  def run_until(game, timestamp), do: run_until(Game.next(game), timestamp)

  def part2() do
    %{prev: prev} =
      get_input()
      |> Enum.reduce(%Game{}, &Game.add_starter(&2, &1))
      |> run_until(30_000_001)

    prev
  end
end
