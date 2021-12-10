defmodule Input do
  def lines(filename) do
    File.read(filename)
    |> then(fn {:ok, contents} -> contents end)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def input, do: lines('input.txt')
  def test, do: lines('test.txt')
end

defmodule Solve do
  def match(")"), do: "("
  def match("]"), do: "["
  def match("}"), do: "{"
  def match(">"), do: "<"
  def match("("), do: ")"
  def match("["), do: "]"
  def match("{"), do: "}"
  def match("<"), do: ">"

  def parse_char(char, {:parsing, stack}) do
    case char do
      "(" -> {:parsing, [char | stack]}
      "[" -> {:parsing, [char | stack]}
      "{" -> {:parsing, [char | stack]}
      "<" -> {:parsing, [char | stack]}
      closing ->
        [last | remaining_stack] = stack
        case match(closing) == last do
          true -> {:parsing, remaining_stack}
          false -> {:corrupt, closing}
        end
    end
  end
  def parse_char(_char, {:corrupt, closing}), do: {:corrupt, closing}

  def parse_line(line) do
    line
    |> Enum.reduce({:parsing, []}, &parse_char/2)
  end

  def score(")"), do: 3
  def score("]"), do: 57
  def score("}"), do: 1197
  def score(">"), do: 25137
  def score(chars) when is_list(chars) do
    char_scores = %{
      ")" => 1,
      "]" => 2,
      "}" => 3,
      ">" => 4
    }
    score = chars
      |> Enum.reduce(0, fn char, score ->
        char_score = Map.get(char_scores, char)
        score * 5 + char_score
      end)
    {chars, score}
  end
end

lines = Input.input |> Enum.map(&Solve.parse_line/1)
lines
  |> Enum.filter(fn {state, _val} -> state == :corrupt end)
  |> Enum.map(fn {_state, val} -> Solve.score(val) end)
  |> Enum.sum
  |> IO.inspect(label: "part one")

scores = lines
  |> Enum.filter(fn {state, _val} -> state == :parsing end)
  |> Enum.map(fn {_state, stack} -> stack end)
  |> Enum.map(&Enum.map(&1, fn c -> Solve.match(c) end))
  |> Enum.map(&Solve.score/1)
  |> Enum.sort_by(fn {_chars, score} -> score end)
middle = floor(length(scores) / 2)
scores
|> Enum.at(middle)
|> then(fn {_chars, score} -> score end)
|> IO.inspect(label: "part two")
