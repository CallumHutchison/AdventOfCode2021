defmodule Day16 do
  def run(input_file_name) do
    {packet, _} =
      load_input(input_file_name)
      |> Binary.from_hexadecimal()
      |> decode_packet

    part1 = sum_version_numbers(packet)
    part2 = calculate_packet_value(packet)

    {part1, part2}
  end

  defp load_input(file_name) do
    File.read!("lib/day16/#{file_name}.txt")
  end

  def decode_packet(packet) do
    version = Enum.slice(packet, 0..2) |> Binary.to_integer()
    id = Enum.slice(packet, 3..5) |> Binary.to_integer()

    decode_packet(Enum.drop(packet, 6), version, id)
  end

  # Literal packet
  def decode_packet(data, version, id = 4) do
    chunks =
      Enum.chunk_while(
        data,
        [],
        fn
          elem, [_, _, _, 1] = acc -> {:cont, Enum.reverse([elem | acc]), []}
          elem, [_, _, _, 0] = acc -> {:cont, Enum.reverse([elem | acc]), :halt}
          _, :halt -> {:halt, :halt}
          elem, acc -> {:cont, [elem | acc]}
        end,
        fn acc -> {:cont, acc} end
      )

    value =
      Enum.flat_map(chunks, fn [_head | tail] -> tail end)
      |> Binary.to_integer()

    remaining_data = Enum.drop(data, Enum.count(chunks) * 5)

    {%{version: version, id: id, value: value}, remaining_data}
  end

  # Operator packet
  def decode_packet([length_type | data], version, id) do
    {children, remaining_data} =
      case length_type do
        0 -> decode_children_by_size(data)
        1 -> decode_children_by_count(data)
      end

    {%{version: version, id: id, children: children}, remaining_data}
  end

  def decode_children_by_count(data) do
    packet_count = Enum.take(data, 11) |> Binary.to_integer()

    Enum.reduce(1..packet_count, {[], Enum.drop(data, 11)}, fn _, {children, data} ->
      {child, remaining_data} = decode_packet(data)
      {[child | children], remaining_data}
    end)
    |> then(fn {children, remaining_data} -> {Enum.reverse(children), remaining_data} end)
  end

  def decode_children_by_size(data) do
    size = Enum.take(data, 15) |> Binary.to_integer()

    data = Enum.drop(data, 15)
    children = Enum.take(data, size) |> decode_packet_array |> Enum.reverse()
    remaining_data = Enum.drop(data, size)

    {children, remaining_data}
  end

  def decode_packet_array(data, packet_so_far \\ []) do
    case decode_packet(data) do
      {packet, []} -> [packet | packet_so_far]
      {packet, remaining_data} -> decode_packet_array(remaining_data, [packet | packet_so_far])
    end
  end

  def sum_version_numbers(%{version: version, children: children}) do
    version + (Enum.map(children, fn child -> sum_version_numbers(child) end) |> Enum.sum())
  end

  def sum_version_numbers(%{version: version}) do
    version
  end

  def calculate_packet_value(%{id: 0, children: children}) do
    Enum.map(children, &calculate_packet_value(&1))
    |> Enum.sum()
  end

  def calculate_packet_value(%{id: 1, children: children}) do
    Enum.map(children, &calculate_packet_value(&1))
    |> Enum.product()
  end

  def calculate_packet_value(%{id: 2, children: children}) do
    Enum.map(children, &calculate_packet_value(&1))
    |> Enum.min()
  end

  def calculate_packet_value(%{id: 3, children: children}) do
    Enum.map(children, &calculate_packet_value(&1))
    |> Enum.max()
  end

  def calculate_packet_value(%{id: 4, value: value}), do: value

  def calculate_packet_value(%{id: 5, children: [first, second]}) do
    if calculate_packet_value(first) > calculate_packet_value(second), do: 1, else: 0
  end

  def calculate_packet_value(%{id: 6, children: [first, second]}) do
    if calculate_packet_value(first) < calculate_packet_value(second), do: 1, else: 0
  end

  def calculate_packet_value(%{id: 7, children: [first, second]}) do
    if calculate_packet_value(first) == calculate_packet_value(second), do: 1, else: 0
  end
end
