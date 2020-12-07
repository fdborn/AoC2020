defmodule Aoc2020.Day04.Answer do
  def part1 do
    validators = [&valid_format?/1]

    get_input!()
    |> Enum.filter(&valid_passport?(&1, validators))
    |> length()
  end

  def part2 do
    validators = [
      &valid_format?/1,
      &valid_byr?/1,
      &valid_iyr?/1,
      &valid_eyr?/1,
      &valid_hgt?/1,
      &valid_hcl?/1,
      &valid_ecl?/1,
      &valid_pid?/1
    ]

    get_input!()
    |> Enum.filter(&valid_passport?(&1, validators))
    |> length()
  end

  defp valid_passport?(passport, validators) do
    Enum.reduce(validators, true, fn validator, is_valid? ->
      is_valid? && validator.(passport)
    end)
  end

  defp valid_format?(%{
         :byr => _,
         :iyr => _,
         :eyr => _,
         :hgt => _,
         :hcl => _,
         :ecl => _,
         :pid => _
       }),
       do: true

  defp valid_format?(_), do: false

  defp valid_byr?(%{:byr => byr}) when byr >= 1920 and byr <= 2002, do: true
  defp valid_byr?(_), do: false

  defp valid_iyr?(%{:iyr => iyr}) when iyr >= 2010 and iyr <= 2020, do: true
  defp valid_iyr?(_), do: false

  defp valid_eyr?(%{:eyr => eyr}) when eyr >= 2020 and eyr <= 2030, do: true
  defp valid_eyr?(_), do: false

  defp valid_hgt?(%{:hgt => {hgt, :cm}}) when hgt >= 150 and hgt <= 193, do: true
  defp valid_hgt?(%{:hgt => {hgt, :in}}) when hgt >= 59 and hgt <= 76, do: true
  defp valid_hgt?(_), do: false

  defp valid_hcl?(%{:hcl => hcl}), do: Regex.match?(~r/#(\d|[a-f]){6}/, hcl)

  defp valid_ecl?(%{:ecl => "amb"}), do: true
  defp valid_ecl?(%{:ecl => "blu"}), do: true
  defp valid_ecl?(%{:ecl => "brn"}), do: true
  defp valid_ecl?(%{:ecl => "gry"}), do: true
  defp valid_ecl?(%{:ecl => "grn"}), do: true
  defp valid_ecl?(%{:ecl => "hzl"}), do: true
  defp valid_ecl?(%{:ecl => "oth"}), do: true
  defp valid_ecl?(_), do: false

  defp valid_pid?(%{:pid => pid}), do: Regex.match?(~r/^\d{9}$/, pid)

  defp get_input! do
    File.read!("input/day04.txt")
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&Regex.split(~r/(\s|\n)/, &1))
    |> Enum.map(fn block ->
      Enum.reduce(block, %{}, fn
        "byr:" <> year, acc -> Map.put(acc, :byr, String.to_integer(year))
        "iyr:" <> year, acc -> Map.put(acc, :iyr, String.to_integer(year))
        "eyr:" <> year, acc -> Map.put(acc, :eyr, String.to_integer(year))
        "hgt:" <> height, acc -> Map.put(acc, :hgt, parse_height(height))
        "hcl:" <> color, acc -> Map.put(acc, :hcl, color)
        "ecl:" <> color, acc -> Map.put(acc, :ecl, color)
        "pid:" <> id, acc -> Map.put(acc, :pid, id)
        "cid:" <> id, acc -> Map.put(acc, :cid, id)
      end)
    end)
  end

  defp parse_height(height) do
    case Regex.run(~r/(\d+)(cm|in)/, height, capture: :all_but_first) do
      [height, "cm"] -> {String.to_integer(height), :cm}
      [height, "in"] -> {String.to_integer(height), :in}
      _ -> nil
    end
  end
end
