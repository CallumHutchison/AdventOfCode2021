defmodule Day02.PartTwo do
  def calculate_distance do
    load_input()
    |> parse_distances
    |> multiply_distances
  end

  defp load_input do
    {:ok, input} = File.read("lib/input.txt")

    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line -> String.split(line, " ") end)
    |> Enum.map(fn [command | distance] ->
      {command, Enum.at(distance, 0) |> String.to_integer()}
    end)
  end

  defp parse_distances(commands) do
    Enum.reduce(
      commands,
      {0, 0, 0},
      fn {command, magnitude}, {horizontal, vertical, aim} ->
        case command do
          "forward" -> {horizontal + magnitude, vertical + aim * magnitude, aim}
          "up" -> {horizontal, vertical, aim - magnitude}
          "down" -> {horizontal, vertical, aim + magnitude}
        end
      end
    )
  end

  defp multiply_distances({horizontal, vertical, _}) do
    horizontal * vertical
  end
end
