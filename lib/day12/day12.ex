defmodule Day12 do
  def run(input_file_name) do
    graph = load_input(input_file_name)
    {count_paths(graph, false), count_paths(graph, true)}
  end

  defp load_input(file_name) do
    File.read!("lib/day12/#{file_name}.txt")
    |> String.split(~r/\R/)
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn [start_node, end_node], graph ->
      add_connection(graph, start_node, end_node)
    end)
  end

  defp add_connection(graph = %{}, start_node, end_node) do
    Map.update(graph, start_node, [end_node], &([end_node] ++ &1))
    |> Map.update(end_node, [start_node], &([start_node] ++ &1))
  end

  # Big caves have their names written in uppercase
  defp is_big_cave(cave_name) do
    String.upcase(cave_name) == cave_name
  end

  defp count_paths(graph = %{}, can_revisit) do
    traverse(graph, can_revisit)
    |> Enum.filter(&(List.last(&1) == "end"))
    |> Enum.count()
  end

  defp traverse(graph = %{}, can_revisit) do
    traverse(graph, "start", MapSet.new(), can_revisit)
  end

  defp traverse(_, "end", _, _) do
    [["end"]]
  end

  defp traverse(graph = %{}, current_node, small_nodes_visited = %MapSet{}, can_revisit) do
    Map.get(graph, current_node)
    |> Enum.filter(&can_visit_cave(&1, small_nodes_visited, can_revisit))
    |> Enum.map(fn node ->
      traverse(
        graph,
        node,
        if(is_big_cave(current_node),
          do: small_nodes_visited,
          else: MapSet.put(small_nodes_visited, current_node)
        ),
        can_still_revisit(node, small_nodes_visited, can_revisit)
      )
      |> Enum.map(fn path -> [current_node | path] end)
    end)
    |> Enum.reduce([], &Enum.reduce(&1, &2, fn path, acc -> [path | acc] end))
  end

  # We can never revisit the start node
  defp can_visit_cave("start", _, _), do: false

  # We can visit any large cave, any small cave we've never visited before, or any cave if we're allowed to revisit
  defp can_visit_cave(node, small_nodes_visited, can_revisit) do
    !MapSet.member?(small_nodes_visited, node) or can_revisit
  end

  # After leaving start, we can still revisit
  defp can_still_revisit("start", _, can_revisit), do: can_revisit
  defp can_still_revisit(_, _, false), do: false
  defp can_still_revisit(node, small_nodes_visited, true) do
    !MapSet.member?(small_nodes_visited, node)
  end
end
