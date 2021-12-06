defmodule Input do
  def lines(filename) do
    File.read(filename)
    |> then(fn {:ok, contents} -> contents end)
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def input, do: lines('input.txt')
  def test, do: lines('test.txt')
end

defmodule PartTwo do
  def init(input) do
    for age <- 0..8, do: %{ new: 0, old: Enum.count(input, &(&1 == age)) }
  end

  def tick(counters) do
    [%{ new: new_dead, old: old_dead } | rest] = counters
    dead = new_dead + old_dead
    %{ new: new_sevens, old: old_sevens } = Enum.at(rest, 6)
    new_counters = List.replace_at(rest, 6, %{ new: new_sevens, old: old_sevens + dead })
    Enum.concat(new_counters, [%{ new: dead, old: 0 }])
  end
end

part_one = PartTwo.init(Input.input)
1..80
|> Enum.reduce(part_one, fn _, counters -> PartTwo.tick(counters) end)
|> Enum.map(fn %{new: new, old: old} -> new + old end)
|> Enum.sum
|> IO.inspect(label: "part one")

part_two = PartTwo.init(Input.input)
1..256
|> Enum.reduce(part_two, fn _, counters -> PartTwo.tick(counters) end)
|> Enum.map(fn %{new: new, old: old} -> new + old end)
|> Enum.sum
|> IO.inspect(label: "part two")
