defmodule Day13 do
  def run(input_file_name) do
    {dots, folds} = load_input(input_file_name)
    part1 = count_dots_after_first_fold(dots, folds)
    print_grid_after_folds(dots, folds)
    {part1, "See output/day13.txt"}
  end

  defp load_input(file_name) do
    File.read!("lib/day13/#{file_name}.txt")
    |> String.split(~r/\R\R/)
    |> Enum.map(&String.split(&1, ~r/\R/))
    |> parse_input
  end

  defp parse_input([coord_lines, fold_lines]) do
    {parse_coords(coord_lines), parse_folds(fold_lines)}
  end

  defp parse_coords(lines) do
    Enum.map(
      lines,
      &(String.split(&1, ",")
        |> then(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end))
    )
    |> MapSet.new()
  end

  defp parse_folds(lines) do
    Enum.map(
      lines,
      &(String.split(&1, " ")
        |> Enum.at(2)
        |> then(fn string -> String.split(string, "=") end)
        |> then(fn [axis, pos] -> {axis, String.to_integer(pos)} end))
    )
  end

  defp count_dots_after_first_fold(dots, folds) do
    fold(dots, Enum.take(folds, 1)) 
    |> Enum.count()
  end

  defp print_grid_after_folds(dots, folds) do
    positions = fold(dots, folds)
    width = Enum.map(positions, fn {x,_y} -> x end) |> Enum.max()
    height = Enum.map(positions, fn {_x,y} -> y end) |> Enum.max()
    grid = Enum.reduce(0..height, "", &(&2 <> grid_line_to_string(positions, &1, width)))
    File.write("output/day13.txt", grid)
  end

  defp grid_line_to_string(dots, y, width) do
    Enum.reduce(0..width, "", &(&2 <> if MapSet.member?(dots, {&1, y}), do: "#", else: " ")) <> "\n"
  end

  defp fold(dots, folds) do
    Enum.reduce(folds, dots, fn 
      {"x", fold_x}, dots -> MapSet.new(dots, fn {x, y} -> {fold_x - abs(x - fold_x), y} end)
      {"y", fold_y}, dots -> MapSet.new(dots, fn {x, y} -> {x, fold_y - abs(y - fold_y)} end)
    end)
  end
end
