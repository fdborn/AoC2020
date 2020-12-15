defmodule Aoc2020.Day12.WaypointCursor do
  defstruct pos: {0, 0},
            waypoint_pos: {10, 1}

  @rot_matrix_left [
    [0, -1],
    [1, 0]
  ]

  @rot_matrix_right [
    [0, 1],
    [-1 , 0]
  ]

  def move(%{waypoint_pos: {x, y}} = cursor, {:north, steps}),
    do: %{cursor | waypoint_pos: {x, y + steps}}

  def move(%{waypoint_pos: {x, y}} = cursor, {:south, steps}),
    do: %{cursor | waypoint_pos: {x, y - steps}}

  def move(%{waypoint_pos: {x, y}} = cursor, {:east, steps}),
    do: %{cursor | waypoint_pos: {x + steps, y}}

  def move(%{waypoint_pos: {x, y}} = cursor, {:west, steps}),
    do: %{cursor | waypoint_pos: {x - steps, y}}

  def move(%{pos: {x, y}, waypoint_pos: {waypoint_x, waypoint_y}} = cursor, {:forward, steps}),
    do: %{cursor | pos: {x + steps * waypoint_x, y + steps * waypoint_y}}

  def move(cursor, {direction, 90}), do: rotate(cursor, direction)

  defp rotate(cursor, :left), do: rotate(cursor, @rot_matrix_left)
  defp rotate(cursor, :right), do: rotate(cursor, @rot_matrix_right)

  defp rotate(%{waypoint_pos: {x, y}} = cursor, matrix) do
    new_x = x * get_nested(matrix, 0, 0) + y * get_nested(matrix, 0, 1)
    new_y = x * get_nested(matrix, 1, 0) + y * get_nested(matrix, 1, 1)

    %{cursor | waypoint_pos: {new_x, new_y}}
  end

  defp get_nested(matrix, x, y), do: matrix |> Enum.at(x) |> Enum.at(y)
end
