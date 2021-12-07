defmodule Day07.Part1 do

  def align_crabs(input_file_name) do
    positions = load_input(input_file_name)
    median = calculate_median(positions)
    calculate_fuel_cost(positions, median)
  end

  defp load_input(file_name) do
    File.read!("lib/#{file_name}.txt")
    |> String.split(",")
    |> Enum.map(&String.to_integer(&1))
  end

  defp calculate_median(positions) do
    Enum.sort(positions)
    |> Enum.at(div(length(positions), 2))
  end

  defp calculate_fuel_cost(positions, target) do
    Enum.map(positions, fn pos -> abs(target - pos) end)
    |> Enum.reduce(&(&1 + &2))
  end
end
