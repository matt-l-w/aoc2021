defmodule Input do
  def lines(filename) do
    File.read(filename)
    |> then(fn {:ok, contents} -> contents end)
    |> String.split("\n", trim: true)
  end

  def input, do: lines('input.txt')
  def test, do: lines('test.txt')
end

