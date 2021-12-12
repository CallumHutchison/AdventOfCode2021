defmodule Day08 do
  def run(input_file_name) do
    outputs =
      load_input(input_file_name)
      |> Enum.map(&decode_output(&1))

    {part1(outputs), part2(outputs)}
  end

  defp part1(outputs) do
    Enum.map(outputs, fn output ->
      Integer.to_string(output)
      |> String.graphemes()
      |> Enum.filter(&(&1 in ["1", "4", "7", "8"]))
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp part2(outputs) do
    Enum.sum(outputs)
  end

  defp load_input(file_name) do
    File.read!("lib/day08/#{file_name}.txt")
    |> String.split(~r/\R/)
    |> Enum.map(&String.split(&1, " | "))
    |> Enum.map(&split_input_digits(&1))
  end

  # Split a signal and output string into a list of signals and a list of outputs  
  defp split_input_digits([singals_string, output_string]) do
    {String.split(singals_string, " "), String.split(output_string, " ")}
  end

  # For a given set of input signals and output signals, return the 4 digit number represented by the output signals
  defp decode_output({input, output}) do
    digits = create_decoder(input)

    Enum.map(output, fn val -> Map.get(digits, get_char_set(val)) end)
    |> Enum.reduce("", &(&2 <> Integer.to_string(&1)))
    |> String.to_integer()
  end

  # Transform a list of inputs into a map of (set(character) -> int) that we can use to decode future inputs
  defp create_decoder(nums) do
    groups = group_digits_by_length(nums)

    # 1,4,7, and 8 have a unique number of segments, so they can be worked out immediately
    num_to_digits = %{
      1 => Map.get(groups, 2) |> List.first(),
      7 => Map.get(groups, 3) |> List.first(),
      4 => Map.get(groups, 4) |> List.first(),
      8 => Map.get(groups, 7) |> List.first()
    }

    Enum.reduce(groups, num_to_digits, fn {_, num_group}, acc ->
      Enum.reduce(num_group, acc, &add_digit_to_map(&1, &2))
    end)
    # Swap keys and values so we can go backwards: from character set to integer
    |> Map.new(fn {key, val} -> {val, key} end)
  end

  defp group_digits_by_length(nums) do
    Enum.reduce(nums, %{}, fn num, acc ->
      Map.update(acc, String.length(num), [get_char_set(num)], fn vals ->
        [get_char_set(num) | vals]
      end)
    end)
  end

  # Convert string to set of characters
  defp get_char_set(string) do
    String.codepoints(string)
    |> MapSet.new()
  end

  # For a set of characters, add it to the
  defp add_digit_to_map(num = %MapSet{}, digit_map) do
    if Map.has_key?(digit_map, num) do
      digit_map
    else
      number =
        case MapSet.size(num) do
          2 -> 1
          4 -> 4
          3 -> 7
          7 -> 8
          6 -> decode_six_segments(num, digit_map)
          5 -> decode_five_segments(num, digit_map)
        end

      Map.put(digit_map, number, num)
    end
  end

  # By comparing the segments of our input against the segments used by a known digit (1,4,7,8),
  # we can uniquely identify which digit this input corresponds to
  defp decode_six_segments(num, digit_map) do
    cond do
      get_digit_intersection_size(num, digit_map, 1) == 1 -> 6
      get_digit_intersection_size(num, digit_map, 4) == 3 -> 0
      true -> 9
    end
  end

  defp decode_five_segments(num, digit_map) do
    cond do
      get_digit_intersection_size(num, digit_map, 1) == 2 -> 3
      get_digit_intersection_size(num, digit_map, 4) == 2 -> 2
      true -> 5
    end
  end

  # How many segments are used by both the input, and an existing digit that's been decoded?  
  defp get_digit_intersection_size(num = %MapSet{}, digit_map = %{}, digit) do
    Map.get(digit_map, digit) |> MapSet.intersection(num) |> MapSet.size()
  end
end
