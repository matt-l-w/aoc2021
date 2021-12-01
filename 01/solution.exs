defmodule One do
  def part_one do
    lines("input.txt") 
    |> count_increases(0) 
  end

  def count_increases([last, next | tail], count) do
    new_count = if next > last, do: count+1, else: count
    count_increases([next | tail], new_count)
  end
  def count_increases([_ | _], count) do
    count
  end

  def part_two do
    lines("input.txt") 
    |> sum_triplets
    |> count_increases(0) 
  end

  def sum_triplets([a, b, c | tail]) do
    sum = a+b+c
    [sum | sum_triplets([b, c | tail])]
  end
  def sum_triplets([a, b | tail]) do
    sum = a+b
    [sum | sum_triplets([b | tail])]
  end
  def sum_triplets([a | _]) do
    a
  end

  def lines(filename) do
    {:ok, contents} = File.read(filename)
    contents
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end


IO.puts One.part_one
IO.puts One.part_two

