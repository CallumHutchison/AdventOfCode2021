defmodule Day04 do
  @grid_size 5

  def load_input(file_name) do
    File.read!("lib/#{file_name}.txt")
    |> String.split(~r/\R\R/)
    |> parse_input
    |> rank_boards
    |> Enum.first()
  end

  defp parse_input([numbers | boards]) do
    {String.split(numbers, ",") |> Enum.map(&String.to_integer(&1)), Enum.map(boards, &create_board(&1))}
  end

  defp create_board(string) do
    String.replace(string, ~r/\R/, " ")
    |> String.split(" ", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {num, i} -> {rem(i, @grid_size), div(i, @grid_size), String.to_integer(num)} end)
    |> create_board_with_numbers
  end

  defp create_board_with_numbers(numbers) do
    Board.new(@grid_size)
    |> Board.set(numbers)
  end

  defp rank_boards({numbers, boards}) do
    Enum.map(boards, fn board -> {board, Board.numbers_to_win(board, numbers)} end)
    |> Enum.sort(fn {_, rank1}, {_, rank2} -> rank1 >= rank2 end)
  end
end
