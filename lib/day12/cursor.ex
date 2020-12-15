defmodule Aoc2020.Day12.Cursor do
  defstruct pos: {0, 0},
            facing: :east

  def move(%{pos: {x, y}} = cursor, {:north, steps}), do: %{cursor | pos: {x, y + steps}}
  def move(%{pos: {x, y}} = cursor, {:south, steps}), do: %{cursor | pos: {x, y - steps}}
  def move(%{pos: {x, y}} = cursor, {:east, steps}), do: %{cursor | pos: {x + steps, y}}
  def move(%{pos: {x, y}} = cursor, {:west, steps}), do: %{cursor | pos: {x - steps, y}}
  def move(%{facing: facing} = cursor, {:forward, steps}), do: move(cursor, {facing, steps})

  def move(%{facing: :north} = cursor, {:left, 90}), do: %{cursor | facing: :west}
  def move(%{facing: :north} = cursor, {:right, 90}), do: %{cursor | facing: :east}

  def move(%{facing: :south} = cursor, {:left, 90}), do: %{cursor | facing: :east}
  def move(%{facing: :south} = cursor, {:right, 90}), do: %{cursor | facing: :west}

  def move(%{facing: :east} = cursor, {:left, 90}), do: %{cursor | facing: :north}
  def move(%{facing: :east} = cursor, {:right, 90}), do: %{cursor | facing: :south}

  def move(%{facing: :west} = cursor, {:left, 90}), do: %{cursor | facing: :south}
  def move(%{facing: :west} = cursor, {:right, 90}), do: %{cursor | facing: :north}
end
