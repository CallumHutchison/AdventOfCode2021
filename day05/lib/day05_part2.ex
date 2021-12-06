defmodule Day05.PartTwo do

  defp load_input(file_name) do
    case File.read("lib/#{file_name}.txt") do
      {:ok, input}  -> parse_input(input)
      _             -> raise("Unable to load input file")
    end
  end

  defp parse_input(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&String.replace(&1, " -> ", " "))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&parse_line(&1))
  end

  defp parse_line(line) do
    Enum.map(line, fn point ->
      String.split(point, ",")
      |> Enum.map(&String.to_integer(&1))
      |> List.to_tuple
    end)
    |> List.to_tuple
  end

  defp create_grid(lines) do
    lines
    |> Enum.reduce(%{}, fn {{x1, y1}, {x2, y2}}, grid ->
        cond do
            x1 == x2    -> vertical_line(grid, y1..y2, x1)
            y1 == y2    -> horizontal_line(grid, x1..x2, y1)
            true        -> diagonal_line(grid, {{x1, y1}, {x2, y2}})
        end
    end)
  end

  defp horizontal_line(grid, x_range, y) do
    Enum.reduce(x_range, grid, &Map.update(&2, {&1, y}, 1, fn val -> val + 1 end))
  end

  defp vertical_line(grid, y_range, x) do
    Enum.reduce(y_range, grid, &Map.update(&2, {x, &1}, 1, fn val -> val + 1 end))
  end

  defp diagonal_line(grid, {{x1, y1}, {x2, y2}}) do
    gradient = div((y2 - y1), (x2 - x1))
    intercept = y1 - (gradient * x1)
    Enum.reduce(x1..x2, grid, &Map.update(&2, {&1, (gradient * &1) + intercept}, 1, fn val -> val + 1 end))
  end

  def count_overlaps(input_file) do
    load_input(input_file)
    |> create_grid
    |> Map.values
    |> Enum.filter(fn val -> val > 1 end)
    |> Enum.count
  end
end
