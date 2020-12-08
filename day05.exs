defmodule Advent do

  def run(filename) do
    filename
    |> load_input()
    |> Stream.map(&find_id/1)

  end

  def load_input(filename) do
    filename
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  def find_id(id) do
    x = String.slice(id, 7..9)
    y = String.slice(id, 0..6)

    calculate(y, 0, 127) * 8 + calculate(x, 0, 7)
  end

  def calculate(string, min, max) when is_binary(string),
    do: calculate(String.to_charlist(string), min, max)
  def calculate([], min, _max), do: min

  def calculate(chars, min, max) when is_list(chars) do
    IO.puts("#{chars}:#{min}:#{max}")
    # FBLR = 70 66 76 82
    [h | t] = chars
    case h do
      70 -> calculate(t, min, min + floor((max - min)/2))
      66 -> calculate(t, min + ceil((max - min)/2), max)
      76 -> calculate(t, min, min + floor((max - min)/2))
      82 -> calculate(t, min + ceil((max - min)/2), max)
    end

  end


end

Advent.find_id("FBFBBFFRLR") |> IO.puts()

Advent.run("day05_input.txt")
|> Enum.max()
|> IO.puts()
