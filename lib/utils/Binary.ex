defmodule Binary do
  def from_hexadecimal(string) do
    String.graphemes(string)
    |> Enum.flat_map(&from_hexadecimal_character/1)
  end

  def from_hexadecimal_character("0"), do: [0, 0, 0, 0]
  def from_hexadecimal_character("1"), do: [0, 0, 0, 1]
  def from_hexadecimal_character("2"), do: [0, 0, 1, 0]
  def from_hexadecimal_character("3"), do: [0, 0, 1, 1]
  def from_hexadecimal_character("4"), do: [0, 1, 0, 0]
  def from_hexadecimal_character("5"), do: [0, 1, 0, 1]
  def from_hexadecimal_character("6"), do: [0, 1, 1, 0]
  def from_hexadecimal_character("7"), do: [0, 1, 1, 1]
  def from_hexadecimal_character("8"), do: [1, 0, 0, 0]
  def from_hexadecimal_character("9"), do: [1, 0, 0, 1]
  def from_hexadecimal_character("A"), do: [1, 0, 1, 0]
  def from_hexadecimal_character("B"), do: [1, 0, 1, 1]
  def from_hexadecimal_character("C"), do: [1, 1, 0, 0]
  def from_hexadecimal_character("D"), do: [1, 1, 0, 1]
  def from_hexadecimal_character("E"), do: [1, 1, 1, 0]
  def from_hexadecimal_character("F"), do: [1, 1, 1, 1]

  def to_integer(binary_list) do
    binary_list
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {val, index} -> val * Integer.pow(2, index) end)
    |> Enum.sum()
  end
end
