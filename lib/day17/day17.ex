defmodule Day17 do
  def run(input_file_name) do
    {min_x..max_x, min_y.._max_y} = target = load_input(input_file_name)

    trajectories =
      Enum.reduce(get_triangular_root(min_x)..max_x, [], fn x, acc ->
        Enum.reduce(min_y..abs(min_y), acc, fn y, acc ->
          if does_trajectory_reach_target?({0, 0}, {x, y}, target),
            do: [{x, y} | acc],
            else: acc
        end)
      end)

    heights_achieved = Enum.map(trajectories, fn {_, y} -> get_max_height(0, y) end)

    {Enum.max(heights_achieved), Enum.count(trajectories)}
  end

  def load_input(file_name) do
    File.read!("lib/day17/#{file_name}.txt")
    |> then(&Regex.scan(~r/-?\d+..-?\d+/, &1))
    |> Enum.concat()
    |> Enum.map(fn range ->
      String.split(range, "..")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn [a, b] -> a..b end)
    |> List.to_tuple()
  end

  def does_trajectory_reach_target?({x, y}, _, {_..max_x, min_y.._}) when x > max_x or y < min_y,
    do: false

  def does_trajectory_reach_target?({x, y}, _, {min_x..max_x, min_y..max_y})
      when x in min_x..max_x and y in min_y..max_y,
      do: true

  def does_trajectory_reach_target?({x, y}, {traj_x, traj_y}, target),
    do:
      does_trajectory_reach_target?(
        {x + traj_x, y + traj_y},
        {max(traj_x - 1, 0), traj_y - 1},
        target
      )

  # Decreases by 1 per step, the velocities act as triangle numbers
  def get_max_height(start, velocity),
    do: start + ((Integer.pow(velocity, 2) + velocity) |> div(2))

  def get_triangular_root(n) do
    div(round(:math.sqrt(8 * n + 1) - 1), 2)
  end
end
