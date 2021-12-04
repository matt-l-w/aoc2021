defmodule Input do
  def lines(filename) do
    File.read(filename)
    |> then(fn {:ok, contents} -> contents end)
    |> String.split("\n", trim: true)
  end

  def input, do: lines('input.txt')
  def test, do: lines('test.txt')
end

defmodule PartOne do
  def numbers(lines) do
    lines
    |> Enum.take(1)
    |> List.first
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def boards(lines) do
    lines
    |> Enum.drop(1)
    |> Enum.chunk_every(5)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.map(fn line ->
      line
      |> String.split
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def rows(board) do
    board
    |> Enum.chunk_every(5)
  end

  def cols(board) do
    0..4
    |> Enum.map(fn col ->
      board
      |> Enum.drop(col)
      |> Enum.take_every(5)
    end)
  end

  def mark(board, num) do
    board
    |> Enum.map(fn n -> 
      case n == num do
        true -> -1
        false -> n
      end
    end)
  end

  def won?(board) do
    any_row_won = board
      |> rows
      |> Enum.any?(fn row -> 
        row
        |> Enum.all?(fn n -> n == -1 end)
      end)
    any_col_won = board
      |> cols
      |> Enum.any?(fn col -> 
        col
        |> Enum.all?(fn n -> n == -1 end)
      end)

    any_row_won || any_col_won
  end

  def play(boards, [num | numbers]) do
    next_round = boards
      |> Enum.map(&PartOne.mark(&1, num))

    case next_round
      |> Enum.filter(&PartOne.won?/1)
      |> List.first do
      nil ->
        next_round
        |> play(numbers)
      winner ->
        [winner, num]
    end
  end

  def score([board, winning_number]) do
    tally = board
      |> Enum.filter(fn n -> n != -1 end)
      |> Enum.sum

    tally * winning_number
  end
end

defmodule PartTwo do
  def play(boards, [num | numbers]) do
    next_round = boards
      |> Enum.map(&PartOne.mark(&1, num))
      |> Enum.reject(&PartOne.won?/1)

    case length(next_round) do
      0 -> 
        [
          boards
          |> List.first
          |> PartOne.mark(num),
          num
        ]
      _ ->
        play(next_round, numbers)
    end
  end
end

boards = Input.input
  |> PartOne.boards
numbers = Input.input
  |> PartOne.numbers

PartOne.play(boards, numbers)
|> PartOne.score
|> IO.inspect

PartTwo.play(boards, numbers)
|> PartOne.score
|> IO.inspect
