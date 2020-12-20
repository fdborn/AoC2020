defmodule Aoc2020.Day15.Game do
  alias Aoc2020.Day15.Game

  defstruct timestamp: 1,
            cache: %{},
            prev: -1

  def add_starter(%Game{timestamp: t, cache: cache, prev: prev}, value) do
    %Game{
      timestamp: t + 1,
      cache: update_cache(cache, t, value),
      prev: prev
    }
  end

  # ugly as sin
  def next(%Game{timestamp: t, cache: cache, prev: prev}) do
    previous_number_occurences = Map.get(cache, prev, [])

    result =
      if length(previous_number_occurences) > 1 do
        head = hd(previous_number_occurences)

        if head != t - 1 do
          t - 1 - head
        else
          t - 1 - Enum.at(previous_number_occurences, 1)
        end
      else
        0
      end

    %Game{
      timestamp: t + 1,
      cache: update_cache(cache, t, result),
      prev: result
    }
  end

  defp update_cache(cache, timestamp, result),
    do: Map.update(cache, result, [timestamp], fn hits -> [timestamp] ++ [hd(hits)] end)
end
