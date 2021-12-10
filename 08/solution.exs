defmodule Input do
  def lines(filename) do
    File.read(filename)
    |> then(fn {:ok, contents} -> contents end)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " | "))
  end

  def input, do: lines('input.txt')
  def test, do: lines('test.txt')
end

defmodule SegmentMapping do
  def calculate(segments) do
    cf = Enum.at(segments, 0) #one
    acf = Enum.at(segments, 1) #seven
    a = acf -- cf

    bcdf = Enum.at(segments, 2) #four
    bd = bcdf -- acf |> List.flatten

    abcdefg = Enum.at(segments, 9) #eight

    aeg = abcdefg -- bcdf
    eg = aeg -- a 

    #two, three, five
    ag = [Enum.at(segments, 3), Enum.at(segments, 4), Enum.at(segments, 5)]
      |> Enum.map(&(&1 -- bcdf))
      |> Enum.filter(&(length(&1) == 2))
      |> List.first
    g = ag -- a
    e = eg -- g

    # zero, six, nine
    b = [Enum.at(segments, 6), Enum.at(segments, 7), Enum.at(segments, 8)]
      |> Enum.map(&(&1 -- cf))
      |> Enum.filter(&(length(&1) == 4))
      |> Enum.map(&(&1 -- aeg))
      |> Enum.filter(&(length(&1) == 1))
      |> List.first
    d = bd -- b

    #two, three, five
    c = [Enum.at(segments, 3), Enum.at(segments, 4), Enum.at(segments, 5)]
      |> Enum.map(&(&1 -- (a ++ d ++ e ++ g)))
      |> Enum.filter(&(length(&1) == 1))
      |> List.first

    f = cf -- c
    %{
      Enum.at(a, 0) => "a",
      Enum.at(b, 0) => "b", 
      Enum.at(c, 0) => "c", 
      Enum.at(d, 0) => "d", 
      Enum.at(e, 0) => "e", 
      Enum.at(f, 0) => "f", 
      Enum.at(g, 0) => "g", 
    }
  end

  def translate(mappings, codes) do
    codes
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Enum.sort/1)
      |> Enum.map(fn chars ->
        translation = chars
          |> Enum.map(&Map.get(mappings, &1))
          |> Enum.sort
          |> Enum.join
        case translation do
          "abcefg" -> 0
          "cf" -> 1
          "acdeg" -> 2
          "acdfg" -> 3
          "bcdf" -> 4
          "abdfg" -> 5
          "abdefg" -> 6
          "acf" -> 7
          "abcdefg" -> 8
          "abcdfg" -> 9
        end
      end)
  end
end

defmodule Solve do
  def part_one(input) do
    input
    |> Enum.map(&Enum.at(&1, 1))
    |> Enum.map(&String.split/1)
    |> Enum.map(fn codes ->
      codes
      |> Enum.map(&String.graphemes/1)
      |> Enum.filter(fn chars -> length(chars) == 7 or length(chars) < 5 end)
    end)
    |> Enum.map(&length/1)
    |> Enum.sum
  end

  def part_two(input) do
    input
    |> Enum.map(&Enum.at(&1, 0))
    |> Enum.map(&String.split/1)
    |> Enum.map(fn codes -> 
      mappings = codes
        |> Enum.map(&String.graphemes/1)
        |> Enum.sort_by(&length/1)
        |> SegmentMapping.calculate

      input
        |> Enum.map(&Enum.at(&1, 1))
        |> Enum.map(&String.split/1)
        |> Enum.map(&SegmentMapping.translate(mappings, &1))
    end)
  end
end


Input.input
|> Solve.part_one
|> IO.inspect(label: "part one")

# Input.test
# |> Solve.part_two
# |> IO.inspect(label: "part two")
