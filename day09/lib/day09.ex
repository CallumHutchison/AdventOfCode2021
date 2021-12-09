defmodule Day09 do
  def run(input_file_name) do
    grid =
      load_input(input_file_name)
      |> create_grid

    low_points = find_low_points(grid)

    IO.puts("Sum of risk levels for lowest points:")
    calculate_risk_levels(low_points)
    |> sum_risk_levels
    |> IO.inspect()

    IO.puts("Product of sizes of three largest basins:")
    calculate_basins(grid, low_points)
    |> find_largest_basin_sizes(3)
    |> multiply_basin_sizes
    |> IO.inspect()

    :ok
  end

  def load_input(file_name) do
    File.read!("lib/#{file_name}.txt")
  end

  defp create_grid(input) do
    grid_size = String.split(input, ~r/\R/) |> List.first() |> String.length()

    String.replace(input, ~r/\R/, "")
    |> String.graphemes()
    |> Enum.map(&String.to_integer(&1))
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {val, i}, acc ->
      Map.put(acc, {rem(i, grid_size), div(i, grid_size)}, val)
    end)
  end

  defp find_low_points(grid = %{}) do
    Enum.filter(grid, fn {{x, y}, val} ->
      Map.get(grid, {x + 1, y}, 10) > val &&
        Map.get(grid, {x - 1, y}, 10) > val &&
        Map.get(grid, {x, y + 1}, 10) > val &&
        Map.get(grid, {x, y - 1}, 10) > val
    end)
  end

  defp calculate_risk_levels(grid) do
    Map.new(grid, fn {{x, y}, height} -> {{x, y}, height + 1} end)
  end

  defp sum_risk_levels(grid = %{}) do
    Map.values(grid)
    |> Enum.sum()
  end

  defp calculate_basins(grid = %{}, low_points) do
    Enum.map(low_points, fn {{x, y}, _} ->
      flood_fill({x, y}, grid)
    end)
  end

  defp find_largest_basin_sizes(basins, count) do
    Enum.map(basins, &Enum.count(&1))
    |> Enum.sort(&(&1 >= &2))
    |> Enum.take(count)
  end

  defp multiply_basin_sizes(sizes) do
    Enum.reduce(sizes, &(&1 * &2))
  end

  defp flood_fill({x, y}, grid, prev_height \\ -1, closed_set \\ %MapSet{}) do
    if MapSet.member?(closed_set, {x, y}) do
      closed_set
    else
      case Map.get(grid, {x, y}) do
        nil ->
          closed_set

        9 ->
          closed_set

        height when prev_height == -1 or height > prev_height ->
          Enum.reduce(
            [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}],
            MapSet.put(closed_set, {x, y}),
            &MapSet.union(&2, flood_fill(&1, grid, height, &2))
          )

        _ ->
          closed_set
      end
    end
  end
end
