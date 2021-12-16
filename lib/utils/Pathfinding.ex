defmodule Pathfinding do
  def find_path(grid = %{}, start, target) do
    unless Map.has_key?(grid, target) and Map.has_key?(grid, target) do
      {:error, "Invalid co-ordinates"}
    else
      calculate_costs(grid, start) |> Map.get(target)
    end
  end

  def calculate_costs(grid, start) do
    costs = %{start => 0}
    queue = PriorityQueue.new() |> PriorityQueue.add({start, 0})
    calculate_costs(grid, queue, costs)
  end

  # If the priority queue is empty, we've explored all nodess
  def calculate_costs(_grid, [], costs), do: costs

  def calculate_costs(grid, queue, costs) do
    {{pos, _distance}, queue} = PriorityQueue.pop(queue)

    {queue, costs} =
      get_neighbours(grid, pos)
      |> Enum.reduce({queue, costs}, fn neighbour, {queue, costs} ->
        update_queue_and_costs(grid, pos, neighbour, queue, costs)
      end)

    calculate_costs(grid, queue, costs)
  end

  defp update_queue_and_costs(grid, pos, neighbour, queue, costs) do
    total_cost = grid[neighbour] + costs[pos]

    if total_cost < Map.get(costs, neighbour, :infinity) do
      queue =
        PriorityQueue.remove(queue, fn
          {^neighbour, _} -> false
          _ -> true
        end)
        |> PriorityQueue.add({neighbour, total_cost}, fn pos -> node_priority(pos) end)

      {queue, Map.put(costs, neighbour, total_cost)}
    else
      {queue, costs}
    end
  end

  defp get_neighbours(grid, {x, y}) do
    Enum.filter([{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}], fn pos ->
      Map.has_key?(grid, pos)
    end)
  end

  defp node_priority({_pos, priority}) do
    priority
  end
end
