
defmodule Advent do

  @target_amount 2020

  def load_input(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def problem1(filename) do
    list = load_input(filename)

    for a <- list do
      for b <- list do
          if a + b== @target_amount do
            IO.puts "#{a} + #{b} = #{@target_amount}: Result: #{a * b}"
          end
      end
    end

  end

  def problem2(filename) do
    list = load_input(filename)

      for a <- list do
        for b <- list do
          for c <-list do
            if a + b + c == @target_amount do
              IO.puts "#{a} + #{b} + #{c} = #{@target_amount}: Result: #{a * b * c}"
            end
          end
        end
      end
    end
end

Advent.problem1("day01_input.txt")
Advent.problem2("day01_input.txt")
