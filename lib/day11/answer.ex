defmodule Aoc2020.Day11.Answer do
  alias Aoc2020.Day11.Automaton

  def part1 do
    get_input!()
    |> Automaton.new()
    |> search_stable_state(&transition_cell_1/2)
    |> Automaton.summarize()
    |> Map.get(:occupied)
  end

  def part2 do
    get_input!()
    |> Automaton.new()
    |> search_stable_state(&transition_cell_2/2)
    |> Automaton.summarize()
    |> Map.get(:occupied)
  end

  def search_stable_state(automaton, transition_fn, last_state \\ %{}) do
    next_state = Automaton.transition(automaton, transition_fn)

    if Map.equal?(next_state, last_state) do
      next_state
    else
      search_stable_state(next_state, transition_fn, next_state)
    end
  end

  def transition_cell_1({_, :floor} = cell, _), do: cell

  def transition_cell_1({pos, cell_state}, automaton) do
    occupied_adjacent =
      automaton
      |> Automaton.adjacent_cells(pos)
      |> Automaton.summarize()
      |> Map.get(:occupied, 0)

    case cell_state do
      :empty when occupied_adjacent == 0 -> {pos, :occupied}
      :occupied when occupied_adjacent >= 4 -> {pos, :empty}
      other_state -> {pos, other_state}
    end
  end

  def transition_cell_2({_, :floor} = cell, _), do: cell

  def transition_cell_2({pos, cell_state}, automaton) do
    occupied_visible =
      automaton
      |> Automaton.visible_cells(pos)
      |> Automaton.summarize()
      |> Map.get(:occupied, 0)

    case cell_state do
      :empty when occupied_visible == 0 -> {pos, :occupied}
      :occupied when occupied_visible >= 5 -> {pos, :empty}
      other_state -> {pos, other_state}
    end
  end

  def get_input!() do
    File.read!("input/day11.txt")
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, pos_y}, grid ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn
        {"L", pos_x} -> {{pos_x, pos_y}, :empty}
        {".", pos_x} -> {{pos_x, pos_y}, :floor}
        {"#", pos_x} -> {{pos_x, pos_y}, :occupied}
      end)
      |> Enum.into(%{})
      |> Map.merge(grid)
    end)
  end
end
