defmodule Day11 do
  @grid_size 10

  def run(input_file_name) do
    grid =
      load_input(input_file_name)
      |> IO.inspect()

    Enum.reduce(1..10, {grid, 0}, fn i, {grid, flashes} ->
      simulate_step(grid)
      |> then(fn {new_grid, new_flashes} ->
        IO.puts("Flashes on step #{i}: #{new_flashes}")
        {new_grid, flashes + new_flashes}
      end)
    end)
    |> IO.inspect()
  end

  defp load_input(file_name) do
    File.read!("lib/#{file_name}.txt")
    |> String.replace(~r/\R/, "")
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {num, i} ->
      {{rem(i, @grid_size), div(i, @grid_size)}, String.to_integer(num)}
    end)
    |> Map.new()
  end

  defp simulate_step(grid) do
    grid = Map.new(grid, fn {pos, energy} -> {pos, energy + 1} end)

    Enum.reduce(grid, {grid, 0}, fn
      {pos, energy}, {grid, flashes} when energy > 9 ->
        set_energy(grid, pos, energy)
        |> then(fn {new_grid, new_flashes} -> {new_grid, new_flashes + flashes} end)

      {_, _}, {grid, flashes} ->
        {grid, flashes}
    end)
  end

  defp set_energy(grid, pos, energy) do
    if energy > 9 do
      flash(grid, pos)
    else
      {Map.put(grid, pos, energy), 0}
    end
  end

  # Return the updated grid, and the number of flashes caused in this chain reaction
  defp flash(grid, {x, y}) do
    Enum.reduce(
      # Neighbours
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
      {Map.put(grid, {x, y}, 0), 1},
      fn
        {i, j}, {grid, flashes} ->
          if Map.has_key?(grid, {i, j}) and grid[{i, j}] != 0 do
            set_energy(grid, {i, j}, grid[{i, j}] + 1)
            |> then(fn {new_grid, new_flashes} -> {new_grid, new_flashes + flashes} end)
          else
            {grid, flashes}
          end
      end
    )
  end
end
