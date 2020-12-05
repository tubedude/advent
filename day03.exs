defmodule Advent do
  def load_input(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
  end

  def run(filename) do
    filename
    |> load_input()
    |> count_travel()
  end

  def count_travel(lines) do
    right = 3
    down = 1

    res = for {l, step} <- Enum.with_index(lines) do
      d = down - 1
      line = String.trim(l)

      # IO.puts(line)
      case {step, rem(step, down)} do
        {^d, _} ->
          IO.puts(line)
          :skip
        {_, 0} ->
          # pos = case rem(step * (right), String.length(line)) + 1 do
          #   0 -> 31
          #   p -> p
          # end
          pos = rem(step * (right), String.length(line)) + 1

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

    res |> Enum.filter(fn x -> x === :tree end) |> Enum.count()
    |> IO.puts()
  end

end

Advent.run("day03_input.txt")
