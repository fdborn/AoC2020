defmodule Aoc2020.Day08.Answer do
  alias Aoc2020.Day08.Computer

  def part1 do
    input = get_input!()

    {:infinite_loop, %{:accumulator => acc}} = Computer.run(%Computer{mem: input})

    acc
  end

  def part2 do
    input = get_input!()

    input
    |> Enum.with_index()
    |> Enum.filter(fn
      {{:jmp, _}, _} -> true
      {{:nop, _}, _} -> true
      _ -> false
    end)
    |> Enum.map(&patch_memory(input, &1))
    |> Enum.reduce_while(nil, fn memory, _ ->
      computer = %Computer{mem: memory}

      case (Computer.run(computer)) do
        {:infinite_loop, _} -> {:cont, nil}
        {:stopped, computer} -> {:halt, computer}
      end
    end)
  end

  defp patch_memory(memory, {{:jmp, value}, offset}),
    do: List.replace_at(memory, offset, {:nop, value})

  defp patch_memory(memory, {{:nop, value}, offset}),
    do: List.replace_at(memory, offset, {:jmp, value})

  defp get_input! do
    File.read!("input/day08.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn
      "acc " <> value -> {:acc, String.to_integer(value)}
      "jmp " <> value -> {:jmp, String.to_integer(value)}
      "nop " <> value -> {:nop, String.to_integer(value)}
    end)
  end
end
