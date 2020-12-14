defmodule Aoc2020.Day11.Automaton do
  alias Aoc2020.Day11.Automaton

  defstruct cells: %{}

  def new(cells) do
    %Automaton{cells: cells}
  end

  def transition(%Automaton{cells: cells} = automaton, cell_transition_fn) do
    new_state =
      cells
      |> Enum.map(fn cell -> cell_transition_fn.(cell, automaton) end)
      |> Enum.into(%{})

    %{automaton | cells: new_state}
  end

  def summarize(%Automaton{cells: cells}), do: summarize(cells)

  def summarize(cells) do
    cells
    |> Enum.reduce(%{}, fn {_, cell}, summary ->
      Map.put(summary, cell, Map.get(summary, cell, 0) + 1)
    end)
  end

  def adjacent_cells(%Automaton{cells: cells}, {x, y}) do
    %{
      # Top row
      {0, 0} => Map.get(cells, {x - 1, y - 1}),
      {1, 0} => Map.get(cells, {x, y - 1}),
      {2, 0} => Map.get(cells, {x + 1, y - 1}),
      # Center row
      {0, 1} => Map.get(cells, {x - 1, y}),
      # Omitting center
      {2, 1} => Map.get(cells, {x + 1, y}),
      # Bottom row
      {0, 2} => Map.get(cells, {x - 1, y + 1}),
      {1, 2} => Map.get(cells, {x, y + 1}),
      {2, 2} => Map.get(cells, {x + 1, y + 1})
    }
  end

  def visible_cells(%Automaton{} = automaton, pos) do
    # Directions (N, NE, E, SE...)
    [
      {0, -1},
      {1, -1},
      {1, 0},
      {1, 1},
      {0, 1},
      {-1, 1},
      {-1, 0},
      {-1, -1}
    ]
    |> Enum.map(
      &find_in_direction(automaton, pos, &1, fn
        :empty -> true
        :occupied -> true
        _ -> false
      end)
    )
    |> Enum.into(%{})
  end

  def find_in_direction(
        %Automaton{cells: cells} = automaton,
        {start_x, start_y},
        {dir_x, dir_y} = direction,
        test_fn
      ) do
    new_pos = {start_x + dir_x, start_y + dir_y}

    case Map.get(cells, new_pos) do
      nil ->
        {new_pos, nil}

      cell ->
        if test_fn.(cell) do
          {new_pos, cell}
        else
          find_in_direction(automaton, new_pos, direction, test_fn)
        end
    end
  end
end
