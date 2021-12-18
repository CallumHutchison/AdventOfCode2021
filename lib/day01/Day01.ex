defmodule Day01 do
  def run(input_file_name) do
    input = load_input(input_file_name)
    {calculate_depth_increases(input, 1), calculate_depth_increases(input, 3)}
  end

  def load_input(file_name) do
    File.read!("lib/day01/#{file_name}.txt")
    |> String.split(~r/\R/)
    |> Enum.map(&String.to_integer/1)
  end

  def calculate_depth_increases(depths, window_size) do
    depths
    |> Enum.chunk_every(window_size, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [x, y] -> y > x end)
    |> Enum.count
  end
end
