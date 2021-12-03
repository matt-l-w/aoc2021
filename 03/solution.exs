defmodule Input do
  def lines(filename) do
    File.read(filename)
    |> then(fn {:ok, contents} -> contents end)
    |> String.split("\n", trim: true)
  end
end

defmodule DayThree do
  def matrix(lines) do
    lines
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
  end

  def count(lines, i) do
    lines
    |> matrix
    |> Enum.map(&Enum.at(&1, i))
    |> Enum.sum
  end

  def most_common(lines, i) do
    lines
    |> count(i)
    |> then(fn sum -> 
      case sum >= length(lines) / 2 do
        true -> 1
        false -> 0
      end
    end)
  end

  def least_common(lines, i) do
    Bitwise.bxor(most_common(lines, i), 1)
  end

  def gamma(lines) do
    0..String.length(List.first(lines))-1
    |> Enum.to_list
    |> Enum.map(fn i -> most_common(lines, i) end)
    |> Enum.join
    |> String.to_integer(2)
  end

  def epsilon(lines) do
    0..String.length(List.first(lines))-1
    |> Enum.to_list
    |> Enum.map(fn i -> least_common(lines, i) end)
    |> Enum.join
    |> String.to_integer(2)
  end

  def one(lines) do
    gamma(lines) * epsilon(lines)
  end

  def o2_rating(lines, i) when length(lines) > 1 do
    filter = most_common(lines, i)
    filtered_lines = lines
      |> Enum.filter(fn line ->
        line
        |> String.split("", trim: true)
        |> Enum.at(i)
        |> String.to_integer
        |> then(fn x -> x == filter end)
      end)
    o2_rating(filtered_lines, i+1)
  end
  def o2_rating(lines, i) when length(lines) == 1 do
    lines
    |> Enum.at(0)
    |> String.to_integer(2) 
  end

  def co2_rating(lines, i) when length(lines) > 1 do
    filter = least_common(lines, i)
    filtered_lines = lines
      |> Enum.filter(fn line ->
        line
        |> String.split("", trim: true)
        |> Enum.at(i)
        |> String.to_integer
        |> then(fn x -> x == filter end)
      end)
    co2_rating(filtered_lines, i+1)
  end
  def co2_rating(lines, i) when length(lines) == 1 do
    lines
    |> Enum.at(0)
    |> String.to_integer(2) 
  end

  def two(lines) do
    co2_rating(lines, 0) * o2_rating(lines, 0)
  end
end

Input.lines('input.txt')
|> DayThree.one
|> IO.inspect

Input.lines('input.txt')
|> DayThree.two
|> IO.inspect
