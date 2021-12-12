defmodule Day11 do
  @grid_size 10

  def run(input_file_name) do
    grid = load_input(input_file_name)

    part1 =
      run_simulation({grid, 0}, 100)
      |> then(fn {_, flashes} -> flashes end)

    part2 = get_first_synchronization(grid)

    {part1, part2}
  end

  defp load_input(file_name) do
    File.read!("lib/day11/#{file_name}.txt")
    |> String.replace(~r/\R/, "")
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {num, i} ->
      {{rem(i, @grid_size), div(i, @grid_size)}, String.to_integer(num)}
    end)
    |> Map.new()
  end

  defp run_simulation({grid, flashes}, 0) do
    {grid, flashes}
  end

  defp run_simulation({grid, flashes}, steps) do
    simulate_step(grid)
    |> then(fn {new_grid, new_flashes} ->
      {new_grid, flashes + new_flashes}
    end)
    |> run_simulation(steps - 1)
  end

  defp simulate_step(grid) do
    grid = Map.new(grid, fn {pos, energy} -> {pos, energy + 1} end)

    Enum.filter(grid, fn {_pos, energy} -> energy > 9 end)
    |> Enum.map(fn {pos, _} -> pos end)
    |> Enum.reduce({grid, 0}, fn pos, {grid, flashes} -> flash(grid, pos, flashes) end)
  end

  defp flash(grid, {x, y} = pos, flashes) do
    Enum.reduce(
      [
        {x - 1, y - 1},
        {x, y - 1},
        {x + 1, y - 1},
        {x - 1, y},
        {x + 1, y},
        {x - 1, y + 1},
        {x, y + 1},
        {x + 1, y + 1}
      ],
      {Map.put(grid, pos, 0), flashes + 1},
      fn neighbour, {grid, flashes} ->
        case Map.get(grid, neighbour, 0) do
          energy when energy == 0 -> {grid, flashes}
          energy when energy == 9 -> flash(grid, neighbour, flashes)
          _ -> {Map.update(grid, neighbour, 1, &(&1 + 1)), flashes}
        end
      end
    )
  end

  defp get_first_synchronization(grid) do
    case simulate_step(grid) do
      {_, flashes} when flashes == @grid_size * @grid_size -> 1
      {new_grid, _} -> 1 + get_first_synchronization(new_grid)
    end
  end
end
