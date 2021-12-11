defmodule Day11 do
  @grid_size 10

  def run(input_file_name) do
    grid = load_input(input_file_name)
    |> IO.inspect()

    Enum.reduce(1..100, {grid, 0}, fn _, {grid, flashes} ->
      simulate_step(grid)
      |> then(fn {new_grid, new_flashes} -> {new_grid, flashes + new_flashes} end)
      |> IO.inspect()
    end)
  end

  defp load_input(file_name) do
    File.read!("lib/#{file_name}.txt")
    |> String.replace(~r/\R/, "")
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {num, i} ->
      {rem(i, @grid_size), div(i, @grid_size), String.to_integer(num)}
    end)
  end

  defp simulate_step(grid) do
    grid = Enum.map(grid, fn {pos, energy} -> {pos, energy + 1} end)

    Enum.filter(grid, fn {_, energy} -> energy > 9 end)
    |> Enum.reduce({grid, 0}, fn {pos, _energy}, {grid, flashes} ->
      flash(grid, pos)
      |> then(fn {new_grid, new_flashes} -> {new_grid, new_flashes + flashes} end)
    end)
  end

  # Return the updated grid, and the number of flashes caused in this chain reaction
  defp flash(grid, {x, y}) do
    if Map.get(grid, {x, y}, -1) < 9 do
      {Map.update(grid, {x, y}, 0, &(&1 + 1)), 0}
    else
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
        {Map.put(grid, {x, y}, 0), 0},
        fn
          {i, j}, {grid, flashes} ->
            if Map.has_key?(grid, {i, j}) do
              flash(grid, {i, j})
              |> then(fn {new_grid, new_flashes} -> {new_grid, new_flashes + flashes} end)
            else
              {grid, flashes}
            end
        end
      )
    end
  end
end
