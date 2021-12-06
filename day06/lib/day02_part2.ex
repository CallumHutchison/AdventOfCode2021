defmodule Day06.Part2 do

  def simulate_lanternfish(input_file_name, days) do
    input = load_input(input_file_name)
    Enum.reduce(1..days, input, &simulate_day(&1, &2))
    |> Map.values()
    |> Enum.reduce(&(&1 + &2))
  end

  defp load_input(file_name) do
    case File.read("lib/#{file_name}.txt") do
      {:ok, input}  -> String.split(input, ",")
                      |> Enum.map(&String.to_integer(&1))
                      |> Enum.reduce(%{}, fn val, acc ->
                        Map.update(acc, val, 1, &(&1 + 1))
                      end)
      _             -> raise("Unable to load input file")
    end
  end

  defp simulate_day(_, fish) do
    # Simulate a day for the population of lanternfish
    # Discrete number of ages allowed, so maintain a map of the number of fish
    # of each age, rather than maintaining an exponential list
    %{
      0 => Map.get(fish, 1, 0),
      1 => Map.get(fish, 2, 0),
      2 => Map.get(fish, 3, 0),
      3 => Map.get(fish, 4, 0),
      4 => Map.get(fish, 5, 0),
      5 => Map.get(fish, 6, 0),
      6 => Map.get(fish, 7, 0) + Map.get(fish, 0, 0),
      7 => Map.get(fish, 8, 0),
      8 => Map.get(fish, 0, 0)
    }
  end

  defp simulate_day_scalable(_, fish) do
    # Shorter, but less readable version of simulate_day
    Enum.reduce(0..7, %{}, &Map.put(&2, &1, Map.get(fish, &1 + 1, 0)))
    |> Map.update(6, Map.get(fish, 0, 0), &(&1 + Map.get(fish, 0, 0)))
    |> Map.put(8, Map.get(fish, 0, 0))
  end
end
