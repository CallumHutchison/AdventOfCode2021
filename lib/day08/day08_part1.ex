# Initial solution for Day 8. Refactored for both parts in Day08.ex
defmodule Day08.Part1 do
  def count_seven_segment_digits(input_file_name) do
    load_input(input_file_name)
    |> Enum.reduce(%{}, &count_digits(&1, &2))
    |> Map.delete(-1)
    |> IO.inspect()
    |> Map.values()
    |> Enum.reduce(&(&1 + &2))
  end

  defp load_input(file_name) do
    File.read!("lib/day08/#{file_name}.txt")
    |> String.split(~r/\R/)
    |> Enum.map(&String.split(&1, " | "))
    |> Enum.map(&split_input_digits(&1))
  end

  defp split_input_digits([singals_string, output_string]) do
    {String.split(singals_string, " "), String.split(output_string, " ")}
  end

  defp count_digits({_, output}, num_map) do
    Enum.reduce(output, num_map, fn val, acc ->
      digit = get_digit_for_string(val)
      Map.update(acc, digit, 1, &(&1 + 1))
    end)
  end

  defp get_digit_for_string(num) do
    case String.length(num) do
      2 -> 1
      4 -> 4
      3 -> 7
      7 -> 8
      _ -> -1
    end
  end
end
