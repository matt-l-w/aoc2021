defmodule Input do
  def lines(filename) do
    File.read(filename)
    |> then(fn {:ok, contents} -> contents end)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " -> "))
    |> List.flatten
    |> Enum.map(fn coord ->
      coord
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.chunk_every(2)
  end

  def input, do: lines('input.txt')
  def test, do: lines('test.txt')
end


defmodule PartOne do
  def grid(lines) do
    with size <- lines
      |> List.flatten
      |> Enum.max
    do
      0..size
      |> Enum.map(fn _ -> Enum.map(0..size, fn _ -> 0 end) end)
    end
  end

  def horizontal?([[x1, _y1], [x2, _y2]]), do: x1 == x2 
  def vertical?([[_x1, y1], [_x2, y2]]), do: y1 == y2 
  def gradient([[x1, y1], [x2, y2]]), do: (y1 - y2)/(x1 - x2)
  def diagonal?(line), do: abs(gradient(line)) == 1
  def type(line) do
    cond do
      horizontal?(line) -> :horizontal
      vertical?(line) -> :vertical
      diagonal?(line) and gradient(line) == 1 -> :diagonal_up
      diagonal?(line) and gradient(line) == -1 -> :diagonal_down
    end
  end

  def increment([x, y], grid) do
    grid
    |> List.update_at(x, fn row ->
      List.update_at(row, y, &(&1 + 1))
    end)
  end

  def mark(grid, []), do: grid
  def mark(grid, [line | lines]) do
    mark(type(line), grid, [line | lines])
  end
  def mark(:vertical, grid, [line | lines]) do
    [[x1, y], [x2, _]] = line
    [x1, x2]
    |> Enum.sort
    |> then(fn [x1, x2] -> x1..x2 end)
    |> Enum.reduce(grid, &increment([&1, y], &2))
    |> mark(lines)
  end
  def mark(:horizontal, grid, [line | lines]) do
    [[x, y1], [_, y2]] = line
    [y1, y2]
    |> Enum.sort
    |> then(fn [y1, y2] -> y1..y2 end)
    |> Enum.reduce(grid, &increment([x, &1], &2))
    |> mark(lines)
  end
  def mark(:diagonal_up, grid, lines) do
    mark(:diagonal, grid, lines, 1)
  end
  def mark(:diagonal_down, grid, lines) do
    mark(:diagonal, grid, lines, -1)
  end
  def mark(:diagonal, grid, [line | lines], step) do
    [a, b] = line
    [[x1, y1], [x2, y2]] = Enum.sort_by([a, b], &List.first/1) 
    xr = x1..x2
    yr = y1..y2//step
    Enum.zip(xr, yr)
    |> Enum.map(fn {x,y} -> [x, y] end)
    |> Enum.reduce(grid, fn point, grid -> increment(point, grid) end)
    |> mark(lines)
  end
end

# grid = Input.input
# |> PartOne.grid
#
# h_or_v_lines = Input.input
#                |> Enum.filter(fn line -> PartOne.horizontal?(line) || PartOne.vertical?(line) end)
#
# grid
# |> PartOne.mark(h_or_v_lines)
# |> List.flatten
# |> Enum.count(&(&1 > 1))
# |> IO.inspect
#
# grid
# |> PartOne.mark(Input.input)
# |> List.flatten
# |> Enum.count(&(&1 > 1))
# |> IO.inspect

defmodule Improved do
  def go do
    File.read("input.txt")
    |> then(fn {:ok, contents} -> contents end)
    |> then(&Regex.scan(~r/\d+/, &1))
    |> Stream.map(fn [x] -> String.to_integer(x) end)
    |> Stream.chunk_every(2)
    |> Stream.chunk_every(2)
    |> Stream.map(&generate_line/1)
    |> Stream.flat_map(&(&1))
    |> Enum.frequencies
    |> Map.values
    |> Enum.filter(&(&1 >= 2))
    |> Enum.count
  end

  def generate_line([[x1, y1], [x2, y2]]) when x1 == x2 do
    for y <- y1..y2//if(y1<y2, do: 1, else: -1), do: {x1, y}
  end
  def generate_line([[x1, y1], [x2, y2]]) when y1 == y2 do
    for x <- x1..x2//if(x1<x2, do: 1, else: -1), do: {x, y1}
  end
  def generate_line([[x1, y1], [x2, y2]]) do
    xrange = x1..x2//if(x1<x2, do: 1, else: -1)
    yrange = y1..y2//if(y1<y2, do: 1, else: -1)
    Enum.zip(xrange, yrange)
  end
end

IO.inspect(Improved.go)
