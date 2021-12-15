defmodule Day14 do
  def run(input_file_name) do
    {template, rules} = load_input(input_file_name)

    part_one =
      run_insertions(template, rules, 10)
      |> most_common_minus_least_common

    part_two =
      run_insertions(template, rules, 40)
      |> most_common_minus_least_common

    {part_one, part_two}
  end

  defp load_input(file_name) do
    File.read!("lib/day14/#{file_name}.txt")
    |> String.split(~r/\R\R/)
    |> then(fn [template, rules] -> {template_to_ngrams(template), parse_rules(rules)} end)
  end

  defp template_to_ngrams(template) do
    String.graphemes(template)
    |> Enum.chunk_every(2, 1, [nil])
    |> Enum.map(&List.to_tuple(&1))
    |> Enum.reduce(%{}, fn ngram, map -> Map.update(map, ngram, 1, fn val -> val + 1 end) end)
  end

  defp parse_rules(rules) do
    String.split(rules, ~r/\R/)
    |> Enum.reduce(%{}, fn
      rule, map -> parse_rule(rule, map)
    end)
  end

  defp parse_rule(rule, map) do
    [pair, element] = String.split(rule, " -> ")
    pair = String.graphemes(pair) |> List.to_tuple()
    Map.put(map, pair, element)
  end

  defp most_common_minus_least_common(polymer) do
    Enum.reduce(polymer, %{}, fn {{char, _}, count}, map ->
      Map.update(map, char, count, &(&1 + count))
    end)
    |> Map.values()
    |> Enum.sort()
    |> then(fn list -> Enum.fetch!(list, -1) - Enum.fetch!(list, 0) end)
  end

  defp run_insertions(polymer, rules, loop_count) do
    Enum.reduce(0..(loop_count - 1), polymer, fn _, acc -> run_insertions(acc, rules) end)
  end

  defp run_insertions(pairs, rules) do
    Enum.flat_map(pairs, fn {pair = {x, y}, count} ->
      if Map.has_key?(rules, pair) do
        insertion = Map.get(rules, pair)
        [{{x, insertion}, count}, {{insertion, y}, count}]
      else
        [{pair, count}]
      end
    end)
    |> Enum.reduce(%{}, fn {pair, count}, map -> Map.update(map, pair, count, &(&1 + count)) end)
  end
end
