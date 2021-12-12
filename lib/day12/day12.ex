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

  defp count_paths(graph = %{}, allow_small_revisits) do
    traverse(graph, allow_small_revisits)
    |> Enum.filter(&(List.last(&1) == "end"))
    |> then(fn paths ->
      if allow_small_revisits, do: Enum.filter(paths, &filter_path(&1)), else: paths
    end)
    |> Enum.count()
  end

  defp filter_path(path) do
    Enum.filter(path, &(!is_big_cave(&1)))
    |> then(&(abs(Enum.count(&1) - (Enum.uniq(&1) |> Enum.count())) <= 1))
  end

  defp traverse(graph = %{}, allow_small_revisits) do
    traverse(graph, "start", MapSet.new(), allow_small_revisits)
  end

  defp traverse(_, "end", _, _) do
    [["end"]]
  end

  defp traverse(graph = %{}, current_node, visited_nodes = %MapSet{}, allow_small_revisits) do
    Map.get(graph, current_node)
    |> Enum.filter(&can_visit_cave(&1, visited_nodes, allow_small_revisits))
    |> Enum.map(fn node ->
      traverse(
        graph,
        node,
        if(is_big_cave(current_node),
          do: visited_nodes,
          else: MapSet.put(visited_nodes, current_node)
        ),
        can_still_revisit(current_node, visited_nodes, allow_small_revisits)
      )
      |> Enum.map(fn path -> [current_node | path] end)
    end)
    |> Enum.reduce([], &Enum.reduce(&1, &2, fn path, acc -> [path | acc] end))
  end

  defp can_visit_cave("start", _, _), do: false

  defp can_visit_cave(node, visited_nodes, allow_small_revisits) do
    !MapSet.member?(visited_nodes, node) or allow_small_revisits
  end

  # After leaving start, we can still revisit
  defp can_still_revisit("start", _, allow_small_revisits), do: allow_small_revisits
  defp can_still_revisit(_, _, false), do: false

  defp can_still_revisit(node, visited_nodes, true) do
    !MapSet.member?(visited_nodes, node)
  end
end
