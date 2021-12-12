defmodule Day10 do
  def run(input_file_name) do
    lines =
      load_input(input_file_name)
      |> parse_lines

    part1 =
      get_syntax_errors(lines)
      |> get_error_score

    part2 =
      get_incomplete_lines(lines)
      |> get_incomplete_scores
      |> get_middle_score

    {part1, part2}
  end

  defp load_input(file_name) do
    File.read!("lib//day10/#{file_name}.txt")
    |> String.split(~r/\R/)
    |> Enum.map(&String.graphemes(&1))
  end

  defp parse_lines(lines) do
    Enum.map(lines, &parse_line(&1, []))
  end

  defp parse_line([input_head | input_tail], stack) do
    case input_head do
      "(" -> parse_line(input_tail, [")"] ++ stack)
      "{" -> parse_line(input_tail, ["}"] ++ stack)
      "[" -> parse_line(input_tail, ["]"] ++ stack)
      "<" -> parse_line(input_tail, [">"] ++ stack)
      symbol when symbol == hd(stack) -> parse_line(input_tail, tl(stack))
      symbol -> {:error, symbol}
    end
  end

  defp parse_line([], []) do
    {:ok}
  end

  defp parse_line([], stack) do
    {:incomplete, stack}
  end

  defp get_syntax_errors(parse_results) do
    Enum.filter(parse_results, &match?({:error, _}, &1))
    |> Enum.map(fn {:error, symbol} -> symbol end)
  end

  defp get_error_score(symbols) do
    Enum.reduce(symbols, 0, &(&2 + get_symbol_score(&1)))
  end

  defp get_symbol_score(")"), do: 3
  defp get_symbol_score("}"), do: 1197
  defp get_symbol_score("]"), do: 57
  defp get_symbol_score(">"), do: 25137

  defp get_incomplete_lines(parse_results) do
    Enum.filter(parse_results, &match?({:incomplete, _}, &1))
    |> Enum.map(fn {:incomplete, stack} -> stack end)
  end

  defp get_incomplete_scores(stacks) do
    Enum.map(stacks, fn stack ->
      Enum.reduce(stack, 0, fn
        ")", acc -> 5 * acc + 1
        "]", acc -> 5 * acc + 2
        "}", acc -> 5 * acc + 3
        ">", acc -> 5 * acc + 4
      end)
    end)
  end

  defp get_middle_score(scores) do
    Enum.sort(scores)
    |> Enum.at(scores |> length() |> div(2))
  end
end
