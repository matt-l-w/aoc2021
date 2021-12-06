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

defmodule PartOne do
  def tick(fish, day\\1)
  def tick(fish, day) when day < 81 do
    fish
    |> Enum.map(&age/1)
    |> List.flatten
    |> tick(day+1)
  end
  def tick(fish, day) when day == 81, do: fish

  def age(fish) when fish == 0, do: [6, 8]
  def age(fish) when fish > 0, do: fish - 1
end

Input.test
|> PartOne.tick
|> Enum.count
|> IO.inspect

