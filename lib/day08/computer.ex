defmodule Aoc2020.Day08.Computer do
  alias Aoc2020.Day08.Computer

  defstruct mem: nil,
            accumulator: 0,
            head: 0,
            history: %MapSet{}

  def run(%Computer{} = computer) do
    case step(computer) do
      {:running, computer} -> run(computer)
      halt -> halt
    end
  end

  def step(%Computer{} = computer) do
    %{
      :mem => mem,
      :accumulator => acc,
      :head => head,
      :history => history
    } = computer

    if MapSet.member?(history, head) do
      {:infinite_loop, computer}
    else
      case Enum.at(mem, head) do
        nil ->
          {:stopped, computer}

        {:acc, value} ->
          {:running,
           %Computer{
             computer
             | accumulator: acc + value,
               history: MapSet.put(history, head),
               head: head + 1
           }}

        {:jmp, value} ->
          {:running,
           %Computer{
             computer
             | history: MapSet.put(history, head),
               head: head + value
           }}

        {:nop, _} ->
          {:running,
           %Computer{
             computer
             | history: MapSet.put(history, head),
               head: head + 1
           }}
      end
    end
  end
end
