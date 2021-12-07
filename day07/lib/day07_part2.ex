defmodule Day07.Part2 do

  def align_crabs(input_file_name) do
    positions = load_input(input_file_name)
    calculate_mean(positions)
    |> Enum.map(&calculate_fuel_cost(positions, &1))
  end

  defp load_input(file_name) do
    File.read!("lib/#{file_name}.txt")
    |> String.split(",")
    |> Enum.map(&String.to_integer(&1))
  end

  defp calculate_mean(positions) do
    mean = Enum.sum(positions) / length(positions)
    # Didn't use the correct method here, but the mean is within 0.5 of the correct answer
    # So one of these ints is the correct target position
    # Not worth optimising
    [floor(mean), ceil(mean)]
  end

  defp calculate_fuel_cost(positions, target) do
    Enum.map(positions, fn pos -> Enum.sum(abs(target - pos)..0) end)
    |> Enum.reduce(&(&1 + &2))
  end
end
