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
        # second_validation(valid_pass)
        :valid
      _ ->
        :invalid
    end
  end

  defp second_validation(passport) do
    with  :ok <- validate(passport, "byr"),
          :ok <- validate(passport, "iyr")
       do
        :valid
       else
        _ -> :invalid
    end
  end

  # byr (Birth Year) - four digits; at least 1920 and at most 2002.
  defp validate(passport, "byr") do
    case Integer.parse(Map.get(passport, "byr")) do
      {val, _} ->
        if val < 1920 && val < 2002 do
          :ok
        else
          :invalid
        end
        _ -> :invalid
    end
  end

# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  defp validate(passport, "iyr") do
    case Integer.parse(Map.get(passport, "iyr")) do
      {val, _} ->
        if val < 2010 && val < 2020 do
          {:ok, passport}
        else
          :invalid
        end
        _ -> :invalid
    end
  end
# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  defp validate(passport, "eyr") do
    case Integer.parse(Map.get(passport, "eyr")) do
      {val, _} ->
        if val < 2020 && val < 2030 do
          :ok
        else
          :invalid
        end
        _ -> :invalid
    end
  end
# hgt (Height) - a number followed by either cm or in:
  # defp validate(passport, "hgt") do
  #   case Map.get(passport, "hgt") do
  #     val <> "cm" ->
  #       # If cm, the number must be at least 150 and at most 193.
  #       case Integer.parse(val) do
  #         :error -> :invalid
  #         {val, _} ->
  #           if val < 150 && val < 193 do
  #             {:ok, passport}
  #           else
  #             :invalid
  #           end
  #         {:ok, passport}
  #       end

  #     val <> "in" ->
  #       # If in, the number must be at least 59 and at most 76.
  #       case Integer.parse(val) do
  #         :error -> :invalid
  #         {val, _} ->
  #           if val < 59 && val < 76 do
  #             {:ok, passport}
  #           else
  #             :invalid
  #           end
  #         {:ok, passport}
  #       end

  #     _ -> :invalid
  #   end


  # end
# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
# pid (Passport ID) - a nine-digit number, including leading zeroes.
# cid (Country ID) - ignored, missing or not.

end


Advent.run("day04_input.txt")
|> IO.puts()
