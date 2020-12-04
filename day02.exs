
defmodule Advent do

  def load_input(filename) do
    filename
    |> File.stream!()
    # |> String.split("\n")
  end

  def run(problem, filename) do
    filename
    |> load_input()
    |> Stream.map(fn f -> parse_line(problem, f) end)
    |> Stream.sum()
    |> IO.puts()
  end

  def parse_line(:b, line) do
    {rule, match, pass} = parse_rule(line)

    [p1, p2] = String.split(rule,"-")
    |> Enum.map(&String.to_integer/1)

    m1 = Enum.at(String.split(pass,""), p1)
    m2 = Enum.at(String.split(pass,""), p2)


    {code, n} = cond do
      (m1 == match && m2 != match) || (m2 == match && m1 != match) ->
        {:valid, 1}
      true ->
        {:invalid, 0}
    end

    IO.puts("Line: #{line} M1: #{m1}/#{p1} and M2: #{m2}/#{p2} -- #{code}")

    n

  end

  def parse_line(:a, line) do
    IO.puts("Line: #{line}")

    {rule, match, pass} = parse_rule(line)

    [min, max] = String.split(rule,"-")
    |> Enum.map(&String.to_integer/1)

    regex = Regex.compile!("#{match}")

    Regex.scan(regex, pass)
    |> Enum.count()
    |> check_pass(min, max)

  end

  defp check_pass(count, min, max) do
    cond do
      min <= count && count <= max ->
        1
      true ->
        0
    end
  end

  defp parse_rule(line) do
    [rule, string, pass] = String.split(line, " ")

    match = String.replace(string, ":", "")

    {rule, match, pass}
  end

end

Advent.run(:b, "day02_input.txt")
