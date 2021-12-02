defmodule Input do
  def lines(filename) do
    {:ok, contents} = File.read(filename)
    contents
    |> String.split("\n")
  end
end

defmodule Submarine do
  def process([line | tail], state) when line == "", do: process(tail, state)

  def process(
    [line | rest],
    state
  ) do
    [instruction, x] = String.split(line) 
    process(rest, handle(state, instruction, String.to_integer(x)))
  end

  def process([], state), do: state

  def handle(state, "forward", x) do
    {_, new_state} = Map.get_and_update(state, :position, fn position ->
      {position, position+x}
    end)
    new_state
  end

  def handle(state, "up", x) do
    {_, new_state} = Map.get_and_update(state, :depth, fn depth ->
      {depth, depth-x}
    end)
    new_state
  end

    def handle(state, "down", x) do
    {_, new_state} = Map.get_and_update(state, :depth, fn depth ->
      {depth, depth+x}
    end)
    new_state
  end
end

defmodule Answer do
  def get(%{ depth: depth, position: position }), do: depth*position
end

Submarine.process(Input.lines("input.txt"), %{ depth: 0, position: 0 })
|> Answer.get
|> IO.puts

defmodule SecondSubmarine do
  def process([line | tail], state) when line == "", do: process(tail, state)

  def process(
    [line | rest],
    state
  ) do
    [instruction, x] = String.split(line) 
    process(rest, handle(state, instruction, String.to_integer(x)))
  end

  def process([], state), do: state

  def handle(state, "forward", x) do
    %{ aim: aim } = state
    state
    |> Map.update!(:position, &(&1+x))
    |> Map.update!(:depth, &(&1 + aim*x))
  end

  def handle(state, "up", x) do
    state
    |> Map.update!(:aim, &(&1 - x))
  end

  def handle(state, "down", x) do
    state
    |> Map.update!(:aim, &(&1 + x))
  end
end


SecondSubmarine.process(Input.lines("input.txt"), %{ depth: 0, position: 0, aim: 0 })
|> Answer.get
|> IO.puts

