defmodule Day15 do
  def run(input_file_name) do
    {grid, {width, height}} = load_input(input_file_name)
    part1 = Pathfinding.find_path(grid, {0, 0}, {width-1, height-1})

    grid = scale_grid(grid, 5, {width, height})

    part2 = Pathfinding.find_path(grid, {0, 0}, {(width * 5)-1, (height * 5)-1})

    {part1, part2}
  end

  defp load_input(file_name) do
    input = File.read!("lib/day15/#{file_name}.txt")

    width = String.split(input, ~r/\R/) |> List.first() |> String.length()
    dimensions = {width, div(String.length(input), width)}

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

  defp scale_grid(grid, factor, {width, height}) do
    Enum.map(0..((factor * factor) - 1), fn i -> 
        {tile_x, tile_y} = {rem(i, factor), div(i, factor)}
        Map.new(grid, fn {{x, y}, risk} -> {{x + (tile_x * width), y + (tile_y * height)}, wrap_risk_level(i, factor, risk)} end)
    end)
    |> Enum.reduce(&Map.merge(&1, &2))
  end

  defp wrap_risk_level(i, factor, risk) do
    rem(i, factor) + div(i, factor) + risk
    |> then(fn 
        x when x > 9 -> rem(x, 9)
        x -> x
    end)
  end
end
