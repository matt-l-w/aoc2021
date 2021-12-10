defmodule Input do
  def lines(filename) do
    File.read(filename)
    |> then(fn {:ok, contents} -> contents end)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.graphemes
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def input, do: lines('input.txt')
  def test, do: lines('test.txt')
end

defmodule Solve do
  def get_coords(lines) do
    lines
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {line, y}, coords ->
      line
      |> Enum.with_index
      |> Enum.reduce(%{}, fn {val, x}, row_coords ->
        Map.merge(row_coords, %{{x, y} => val})
      end)
      |> Map.merge(coords)
    end)
  end

  def surrounding(coords, {x, y}) do
    Map.take(coords, [
      {x, y-1},
      {x+1, y},
      {x, y+1},
      {x-1, y}
    ])
    |> Map.filter(fn {coord, x} -> !is_nil(x) end)
  end

  def min(coords, coord) do
    center = Map.get(coords, coord)
    surrounding(coords, coord)
    |> Map.values
    |> then(&Enum.all?(&1, fn x -> center < x end))
  end

  def basin(coords, point, visited\\[]) do
    current_value = Map.get(coords, point)
    next_points = surrounding(coords, point)
      |> Map.filter(fn {_coord, x} -> x > current_value end)
      |> Map.filter(fn {_coord, x} -> x < 9 end)
      |> Map.filter(fn {coord, _x} -> coord not in visited end)
      |> Map.keys

    case length next_points do
      0 ->
        [point | visited]
      _ -> 
        Enum.map(next_points, &(basin(coords, &1, [point | visited])))
    end
  end
end

coords = Input.input |> Solve.get_coords
low_points = coords
  |> Map.filter(fn {coord, _val} ->
    Solve.min(coords, coord)
  end)
  |> Map.map(fn {_coord, val} -> val + 1 end)

low_points
|> Map.values
|> Enum.sum
|> IO.inspect(label: "part one")

low_points
|> Map.keys
|> Enum.map(&Solve.basin(coords, &1))
|> Enum.map(fn basin ->
  basin
  |> List.flatten
  |> Enum.uniq
end)
|> Enum.sort_by(&(-length(&1)))
|> Enum.take(3)
|> Enum.map(&length/1)
|> Enum.reduce(1, &*/2)
|> IO.inspect(label: "part two")
