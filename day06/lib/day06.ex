defmodule Day06.Part1 do

  def simulate_lanternfish(input_file_name, days) do
    input = load_input(input_file_name)
    Enum.reduce(1..days, input, &simulate_day(&1, &2))
    |> Enum.count()
  end

  defp simulate_day(_,list) do
    decrease_timers(list) ++ spawn_new_fish(list)
  end

  defp decrease_timers(list) do
    Enum.map(list, fn val -> if val == 0, do: 6, else: val - 1 end)
  end

  defp spawn_new_fish(list) do
    Enum.filter(list, fn val -> val == 0 end)
    |> Enum.map(fn _ -> 8 end)
  end

  defp load_input(file_name) do
    case File.read("lib/#{file_name}.txt") do
      {:ok, input}  -> String.split(input, ",") |> Enum.map(&String.to_integer(&1))
      _             -> raise("Unable to load input file")
    end
  end
end
