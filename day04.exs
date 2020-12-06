defmodule Advent do

  @entity_split "\n\n"

  defp load_input(filename) do
    filename
    |> File.read!()
    |> String.split(@entity_split)
  end

  def run(filename) do
    filename
    |> load_input()
    |> Enum.map(&replace_spaces/1)
    |> Enum.map(&split_fields/1)
    |> Enum.map(&validate_passport/1)
    |> Enum.filter(fn p -> p == :valid end)
    |> Enum.count()

  end

  defp replace_spaces(entity) do
    entity
    |> String.replace("\n", " ")
  end

  defp split_fields(line) do
    # IO.puts(line)
    line
    |> String.split(" ")
    |> reduce_fields()
  end

  defp reduce_fields(line) do
    line
    |>Enum.reduce(%{}, fn(blob, acc) -> [k,v] = String.split(blob, ":", [:parts, 2]); Map.put(acc, k, v) end)
  end

  defp validate_passport(passport) do
    case passport do
      %{"byr" => _, "iyr" => _, "eyr" => _ , "hgt" => _, "hcl" => _, "ecl" => _, "pid" => _} = valid_pass->
        second_validation(valid_pass)
        # :valid
      _ ->
        :invalid
    end
  end

  defp second_validation(passport) do
    with  :ok <- validate(passport, "byr"),
    :ok <- validate(passport, "iyr"),
    :ok <- validate(passport, "eyr"),
    :ok <- validate(passport, "hgt"),
    :ok <- validate(passport, "hcl"),
    :ok <- validate(passport, "ecl"),
    :ok <- validate(passport, "pid")
    do
        :valid
       else
        _ -> :invalid
    end
  end

  # byr (Birth Year) - four digits; at least 1920 and at most 2002.
  defp validate(passport, "byr") do
    r = case Integer.parse(Map.get(passport, "byr")) do
      {val, _} -> validate_amount(val, 1920, 2002)
        _ -> :invalid
    end
    # IO.puts("byr: #{Map.get(passport, "byr")} - #{r}")
    r
  end

# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  defp validate(passport, "iyr") do
    r = case Integer.parse(Map.get(passport, "iyr")) do
      {val, _} -> validate_amount(val, 2010, 2020)
        _ -> :invalid
    end
    # IO.puts("iyr: #{Map.get(passport, "iyr")} - #{r}")
    r
  end
# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  defp validate(passport, "eyr") do
    r = case Integer.parse(Map.get(passport, "eyr")) do
      {val, _} -> validate_amount(val, 2020, 2030)
        _ -> :invalid
    end
    # IO.puts("eyr: #{Map.get(passport, "eyr")} - #{r}")
    r
  end
# hgt (Height) - a number followed by either cm or in:
  defp validate(passport, "hgt") do
    r = Regex.named_captures(~r/^(?<val>^\d*)(?<unit>cm|in)$/ ,Map.get(passport, "hgt"))
    res = case r do
      %{"val" => val, "unit" => unit} -> validate_height(String.to_integer(val), unit)
      _ -> :invalid
    end
    IO.puts("#{Map.get(passport, "hgt")} - #{inspect(r)} - #{res}")
    res
  end

# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
defp validate(passport, "hcl") do
  res = case Regex.match?(~r/^#[\da-f]{6}$/, Map.get(passport, "hcl")) do
    true -> :ok
    false -> :invalid
  end
  # IO.puts("hcl #{Map.get(passport, "hcl")} - #{res}")
  res

end
# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
defp validate(passport, "ecl") do
  res = case Regex.match?(~r/^(amb|blu|brn|gry|hzl|oth)$/ ,Map.get(passport, "ecl")) do
    true -> :ok
    false -> :invalid
  end
  # IO.puts("#{Map.get(passport, "ecl")} - #{res}")
  res

end
# pid (Passport ID) - a nine-digit number, including leading zeroes.
defp validate(passport, "pid") do
  r = case Regex.match?(~r/\d{9}/  ,Map.get(passport, "pid")) do
    true -> :ok
    false -> :invalid
  end
  # IO.puts("#{Map.get(passport, "pid")} - #{r}")
  r

end
# cid (Country ID) - ignored, missing or not.


  defp validate_amount(val, min, max) do
    if val >= min && val <= max do
      :ok
    else
      :error
    end
  end

  # If cm, the number must be at least 150 and at most 193.
  defp validate_height(val, "cm"), do: validate_amount(val, 150, 193)
  # If in, the number must be at least 59 and at most 76.
  defp validate_height(val, "in"), do: validate_amount(val,  59,  76)

end


Advent.run("day04_input.txt")
# |>Enum.dedup()
|> IO.puts()
