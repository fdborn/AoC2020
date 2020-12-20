defmodule Aoc2020.Day16.Answer do
  def get_input() do
    [rules, my_ticket, other_tickets] =
      File.read!("input/day16.txt")
      |> String.split("\n\n", trim: true)

    my_ticket =
      my_ticket
      |> String.split("\n", trim: true)
      |> Enum.drop(1)
      |> parse_tickets()
      |> hd()

    other_tickets =
      other_tickets
      |> String.split("\n", trim: true)
      |> Enum.drop(1)
      |> parse_tickets()

    %{
      rules: parse_rules(rules),
      my_ticket: my_ticket,
      other_tickets: other_tickets
    }
  end

  def parse_rules(rules) do
    String.split(rules, "\n", trim: true)
    |> Enum.map(fn line ->
      [rule_name, first_range, second_range] =
        Regex.run(~r/(.+):\s(\d+-\d+)\sor\s(\d+-\d+)/, line, capture: :all_but_first)

      {rule_name, [parse_range(first_range), parse_range(second_range)]}
    end)
  end

  def parse_range(range) do
    String.split(range, "-")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def parse_tickets(tickets) do
    Enum.map(tickets, fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  #
  # This is where the thing actually starts
  #

  def part1 do
    input = get_input()

    input.other_tickets
    |> Enum.flat_map(fn ticket ->
      ticket
      |> Enum.find([], fn field -> !match_rules?(input.rules, field) end)
      |> List.wrap()
    end)
    |> Enum.reduce(&Kernel.+/2)
  end

  def match_rules?(rules, value) do
    rules
    |> Enum.find_value(false, fn rule -> match_rule?(rule, value) end)
  end

  def match_rule?({_, ranges}, value) do
    [{left_lower, left_upper}, {right_lower, right_upper}] = ranges

    (value >= left_lower && value <= left_upper) ||
      (value >= right_lower && value <= right_upper)
  end

  def part2 do
    input = get_input()

    ticket_errors =
      input.other_tickets
      |> Enum.reject(fn ticket ->
        ticket
        |> Enum.find(false, fn field -> !match_rules?(input.rules, field) end)
      end)
      |> Kernel.++([input.my_ticket])
      |> Enum.flat_map(fn ticket ->
        ticket
        |> Enum.with_index()
        |> Enum.flat_map(fn {field, index} ->
          with [{rule_name, _}] <- Enum.reject(input.rules, &match_rule?(&1, field)) do
            [{rule_name, index}]
          else
            _ -> []
          end
        end)
      end)

    all_rule_names =
      input.rules
      |> Enum.map(fn {name, _} -> name end)

    possible_rules =
      for offset <- 0..(length(all_rule_names) - 1), into: %{} do
        {offset, all_rule_names}
      end

    final_rules =
      ticket_errors
      |> Enum.into([])
      |> eliminate_impossible(possible_rules)
      |> Enum.map(fn {key, value} -> {value, key} end)
      |> Enum.into(%{})

    all_rule_names
    |> Enum.filter(&Kernel.match?("departure" <> _, &1))
    |> Enum.map(&Map.get(final_rules, &1))
    |> Enum.map(&Enum.at(input.my_ticket, &1))
    |> Enum.reduce(&Kernel.*/2)
  end

  def eliminate_impossible(errors, rules, result \\ %{}) do
    certain =
      errors
      |> Enum.reduce(rules, fn {name, offset}, rules ->
        Map.update!(rules, offset, &List.delete(&1, name))
      end)
      |> Enum.filter(fn
        {_, [_]} -> true
        _ -> false
      end)

    {result, possible_rules} =
      certain
      |> Enum.reduce({result, rules}, fn {offset, [name]}, {result, rules} ->
        new_result = Map.put(result, offset, name)

        new_possible_rules =
          rules
          |> Enum.map(fn {offset, values} -> {offset, List.delete(values, name)} end)
          |> Enum.into(%{})

        {new_result, new_possible_rules}
      end)

    case certain do
      [] -> result
      _ -> eliminate_impossible(errors, possible_rules, result)
    end
  end
end
