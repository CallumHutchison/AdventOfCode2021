defmodule Day12 do
  def run(input_file_name) do
    graph = load_input(input_file_name)

    part_one =
      traverse(graph, false)
      |> IO.inspect()
      |> Enum.filter(&(List.last(&1) == "end"))
      |> Enum.count()

    part_two =
      traverse(graph, true)
      |> IO.inspect()
      |> Enum.filter(&(List.last(&1) == "end"))
      |> Enum.count()

    {part_one, part_two}
  end

  def load_input(file_name) do
    File.read!("lib/#{file_name}.txt")
    |> String.split(~r/\R/)
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn [start_node, end_node], graph ->
      add_connection(graph, start_node, end_node)
    end)
  end

  def add_connection(graph = %{}, start_node, end_node) do
    Map.update(graph, start_node, [end_node], &([end_node] ++ &1))
    |> Map.update(end_node, [start_node], &([start_node] ++ &1))
  end

  # Big caves have their names written in uppercase
  def is_big_cave(cave_name) do
    String.upcase(cave_name) == cave_name
  end

  def traverse(graph = %{}, allow_small_revisits) do
    traverse(graph, "start", MapSet.new(), allow_small_revisits)
  end

  def traverse(_, "end", _, _) do
    [["end"]]
  end

  def traverse(graph = %{}, current_node, visited_nodes = %MapSet{}, allow_small_revisits) do
    Map.get(graph, current_node)
    |> Enum.filter(
      &(&1 != "start" &&
          (is_big_cave(&1) or !MapSet.member?(visited_nodes, &1) or allow_small_revisits))
    )
    |> Enum.map(fn node ->
      traverse(
        graph,
        node,
        MapSet.put(visited_nodes, current_node),
        if(allow_small_revisits,
          do: current_node == "start" or is_big_cave(current_node) or !MapSet.member?(visited_nodes, current_node),
          else: false
        )
      )
      |> Enum.map(fn path -> [current_node | path] end)
    end)
    |> Enum.reduce([], &Enum.reduce(&1, &2, fn path, acc -> [path | acc] end))
  end
end
