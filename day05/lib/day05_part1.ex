defmodule Day05.PartOne do
  defp load_input(file_name) do
    case File.read("lib/#{file_name}.txt") do
      {:ok, input} -> parse_input(input)
      _ -> raise("Unable to load input file")
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
      |> List.to_tuple()
    end)
    |> List.to_tuple()
  end

  defp filter_diagonals(lines) do
    Enum.filter(lines, fn line ->
      case line do
        {{x, _}, {x, _}} -> true
        {{_, y}, {_, y}} -> true
        _ -> false
      end
    end)
  end

  defp create_grid(lines) do
    lines
    |> Enum.reduce(%{}, fn {{x1, y1}, {x2, y2}}, grid ->
      Enum.reduce(x1..x2, grid, fn x, grid ->
        Enum.reduce(y1..y2, grid, fn y, grid ->
          Map.update(grid, {x, y}, 1, fn val -> val + 1 end)
        end)
      end)
    end)
  end

  def count_overlaps(input_file) do
    load_input(input_file)
    |> filter_diagonals
    |> create_grid
    |> Map.values()
    |> Enum.filter(fn val -> val > 1 end)
    |> Enum.count()
  end
end
