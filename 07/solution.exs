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

defmodule Solve do
  def part_one(positions) do
    start = Enum.min(positions)
    finish = Enum.max(positions)

    start..finish
    |> Enum.map(fn x ->
      cost = positions
        |> Enum.map(fn x2 -> abs(x2 - x) end)
        |> Enum.sum
      { x, cost }
    end)
    |> Enum.min_by(fn {_x, cost} -> cost end)
  end

  def part_two(positions) do
    start = Enum.min(positions)
    finish = Enum.max(positions)

    start..finish
    |> Enum.map(fn x ->
      cost = positions
             |> Enum.map(fn x2 -> if(x2 == x, do: 0, else: Enum.sum(1..abs(x2 - x))) end)
             |> Enum.sum
      { x, cost }
    end)
    |> Enum.min_by(fn {_x, cost} -> cost end)
  end
end

Input.input
|> Solve.part_one
|> IO.inspect(label: "part one")

Input.input
|> Solve.part_two
|> IO.inspect(label: "part two")
