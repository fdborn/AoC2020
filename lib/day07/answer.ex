defmodule Aoc2020.Day07.Answer do
  @target_bag "shiny gold"

  def part1 do
    # Remove amount from items
    rules =
      get_input!()
      |> Enum.map(fn {key, value} ->
        {key, Enum.map(value, &Regex.replace(~r/\d+\s?/, &1, ""))}
      end)
      |> Enum.into(%{})

    rules
    |> Map.keys()
    |> Enum.filter(&has_descendant?(rules, &1, @target_bag))
    # Ignore target bag
    |> Enum.drop(1)
    |> length()
  end

  def part2 do
    # Update ruleset with amount of children
    rules =
      get_input!()
      |> Enum.map(fn {key, value} ->
        bag_tuples =
          value
          |> Enum.flat_map(&extract_amount/1)

        {key, bag_tuples}
      end)
      |> Enum.into(%{})

    # Ignore target bag
    accumulate_node_values(rules, @target_bag) - 1
  end

  defp has_descendant?(_, start, target) when start == target, do: true

  defp has_descendant?(rules, start, target) do
    case Map.get(rules, start) do
      nil -> false
      descendants -> Enum.any?(descendants, &has_descendant?(rules, &1, target))
    end
  end

  defp extract_amount(bag_string) do
    case Regex.run(~r/(\d+)\s?(\w+\s\w+)$/, bag_string, capture: :all_but_first) do
      [number, color] -> [{String.to_integer(number), color}]
      _ -> []
    end
  end

  defp accumulate_node_values(rules, start) do
    case Map.get(rules, start) do
      [] ->
        1

      children ->
        Enum.reduce(children, 1, fn {amount, name}, acc ->
          acc + amount * accumulate_node_values(rules, name)
        end)
    end
  end

  defp get_input!() do
     File.read!("input/day07.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [head | tail] =
        Regex.scan(~r/((?>\d+\s)?\w+\s\w+)\sbags?/U, line, capture: :all_but_first)
        |> List.flatten()

      {head, tail}
    end)
    |> Enum.into(%{})
  end
end
