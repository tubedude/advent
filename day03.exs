defmodule Advent do
  def load_input(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
  end

  def run(filename, right, down) do
    filename
    |> load_input()
    |> count_travel(right, down)
  end

  def count_travel(lines, right, down) do

    res = for {l, step} <- Enum.with_index(lines) do
      # d = down - 1
      line = String.trim(l)

      # IO.puts(line)
      case {step, rem(step, down)} do
        {0, _} ->
          IO.puts(line)
          :start
        {_, 1} ->
          IO.puts(line)
          :skip
        {_, 0} ->
          pos = rem(ceil(step / down) * (right), String.length(line)) + 1

          case String.at(line, pos - 1) do
            nil ->
              IO.puts("#{line} Step: #{step} - Pos:  #{pos} #{String.length(line)}")
              :skip
            "." ->
              x = String.split(line, "") |> List.replace_at(pos, "0") |> Enum.join("")
              "#{x} Step: #{step} - Pos:  #{pos}"
              |> IO.puts()
              :free
            "#" ->
              x = String.split(line, "") |> List.replace_at(pos, "X") |> Enum.join("")
              "#{x} Step: #{step} - Pos:  #{pos}"
              |> IO.puts()
              :tree
          end
      end
    end
    IO.puts("Finished")
    IO.puts(inspect(res))

    r = res |> Enum.filter(fn x -> x === :tree end) |> Enum.count()
    IO.puts(r)
    r
  end

end

  # Advent.run("day03_input.txt", 1, 2)

x = [
  {1, 1},
  {3, 1},
  {5, 1},
  {7, 1},
  {1, 2},
] |> Enum.map(fn {r, d} ->
  Advent.run("day03_input.txt", r, d)
  end)
IO.puts(inspect(x))
  # |> Enum.reduce(fn n, acc -> n * acc end)
