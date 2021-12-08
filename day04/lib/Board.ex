defmodule Board do
  def new(size) do
    %{size: size}
  end

  def set(board = %{}, numbers) do
    Enum.reduce(numbers, board, fn {x, y, number}, acc -> set(acc, x, y, number) end)
  end

  def set(board = %{}, x, y, number) do
    Map.put(board, {x, y}, {number, false})
    |> Map.put(number, {x, y})
  end

  def mark(board = %{}, number) do
    Map.put(board, Map.get(board, number), {number, true})
  end

  def get_marked_nums(board = %{}) do
    Enum.filter(board, fn
      {{_, _}, {_, true}} -> true
      _ -> false
    end)
    |> Enum.map(fn {{_, _}, {num, _}} -> num end)
  end

  def get_unmarked_nums(board = %{}) do
    Enum.filter(board, fn
      {{_, _}, {_, false}} -> true
      _ -> false
    end)
    |> Enum.map(fn {{_, _}, {num, _}} -> num end)
  end

  def numbers_to_win(_board = %{}, []) do
    throw("This board will never win")
  end

  def numbers_to_win(board = %{}, [head | tail]) do
    board = Board.mark(board, head)

    if has_won(board) do
      1
    else
      1 + numbers_to_win(board, tail)
    end
  end

  def has_won(board = %{}) do
    size = Map.get(board, :size)

    Enum.reduce_while(0..size, board, fn i, _ ->
      if has_won_column(board, i) || has_won_row(board, i),
        do: {:halt, true},
        else: {:cont, false}
    end)
  end

  def has_won_row(board = %{}, row) do
    Enum.filter(board, fn
      {{_, ^row}, {_, true}} -> true
      {_, _} -> false
    end)
    |> Enum.count() == Map.get(board, :size)
  end

  def has_won_column(board = %{}, column) do
    Enum.filter(board, fn
      {{^column, _}, {_, true}} -> true
      {_, _} -> false
    end)
    |> Enum.count() == Map.get(board, :size)
  end
end
