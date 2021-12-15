defmodule Day15 do
  def run(input_file_name) do
    {grid, dimensions} = load_input(input_file_name)
    {path, _, _} = find_shortest_path(grid, {0, 0}, dimensions)
    [start | path] = Enum.reverse(path)
    {path, path_cost(path, grid)}
  end

  defp load_input(file_name) do
    input = File.read!("lib/day15/#{file_name}.txt")

    width = String.split(input, ~r/\R/) |> List.first() |> String.length()
    dimensions = {width - 1, div(String.length(input), width) - 1}

    grid =
      input
      |> String.replace(~r/\R/, "")
      |> String.graphemes()
      |> Enum.map(&String.to_integer(&1))
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {risk, index}, grid ->
        Map.put(grid, {rem(index, width), div(index, width)}, risk)
      end)

    {grid, dimensions}
  end

  defp find_shortest_path(grid, start, target) do
    find_shortest_path(grid, start, target, [], %{})
  end

  defp find_shortest_path(grid, pos, target, path, costs = %{}) when pos == target do
    path = [pos | path]
    IO.puts("#{path_cost(path, grid)}")
    {path, path_cost(path, grid), costs}
  end

  defp find_shortest_path(grid, pos, target, path, costs = %{}) do
    # Adjacent tiles that haven't been visited yet for this path
    neighbours =
      get_neighbours(grid, pos, path, costs)
      |> sort_neighbours(grid, target)

    # If a neighbour has passed the filter, then this is the fastest path to that node found so far
    # Update the costs map
    costs = Enum.reduce(neighbours, costs, &Map.put(&2, &1, path_cost([&1 | path], grid)))

    Enum.reduce(neighbours, {nil, nil, costs}, fn
       neighbour, {shortest_path, min_cost, costs} -> find_shortest_path(grid, neighbour, target, [pos | path], costs) |> then(fn 
            {nil, _, costs} -> {shortest_path, min_cost, costs}
            {path, cost, costs} when cost <= min_cost -> {path, cost, costs}
            {_, _, costs} -> {shortest_path, min_cost, costs}
        end)
    end)
  end

  defp get_neighbours(grid, {x, y}, path, costs) do
    Enum.filter([{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}], fn pos ->
      Map.has_key?(grid, pos) && pos not in path &&
        (!Map.has_key?(costs, pos) || path_cost([pos | path], grid) <= Map.get(costs, pos))
    end)
  end

  defp sort_neighbours(neighbours, grid, target) do
    Enum.sort_by(neighbours, fn pos ->
      Float.pow(distance(pos, target), 2) + Map.get(grid, pos)
    end)
  end

  defp path_cost(path, grid) do
    Enum.map(path, fn node -> Map.get(grid, node) end)
    |> Enum.sum()
  end

  defp distance({x1, y1}, {x2, y2}) do
    :math.sqrt(Integer.pow(x1 - x2, 2) + Integer.pow(y2 - y1, 2))
  end
end
