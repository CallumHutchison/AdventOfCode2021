defmodule Day14 do
    def run(input_file_name) do
        {template, rules} = load_input(input_file_name) |> IO.inspect()
        run_insertions(template, rules, 10)
        |> part_one
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

    defp part_one(polymer) do
        Enum.reduce(polymer, %{}, &Map.update(&2, &1, 1, fn val -> val + 1 end))
        |> Map.values()
        |> Enum.sort()
        |> IO.inspect()
        |> then(fn list -> Enum.fetch!(list, -1) - Enum.fetch!(list, 0) end)
    end

    defp run_insertions(polymer, rules, loop_count) do
        Enum.reduce(0..(loop_count-1), polymer, fn _, acc -> run_insertions(acc, rules) end)
    end

    defp run_insertions(pairs, rules) do
        if Map.has_key?(rules, {head, hd(tail)}) do
            [head] ++ [Map.get(rules, {head, hd(tail)}, "")] ++ run_insertions(tail, rules)
        else 
            [head | run_insertions(tail, rules)]
        end
    end
end