defmodule Day18 do
  def run(input_file_name) do
    numbers = load_input(input_file_name)

    part1 =
      numbers
      |> Enum.reduce(&add(&2, &1))
      |> magnitude()

    # get all combinations
    combinations = for x <- numbers, y <- numbers, x != y, do: [x, y]

    part2 =
      Enum.map(combinations, fn [num1, num2] -> add(num1, num2) |> magnitude end)
      |> Enum.max()

    {part1, part2}
  end

  def load_input(file_name) do
    File.read!("lib/day18/#{file_name}.txt")
    |> String.split(~r/\R/)
    |> Enum.map(&parse_snailfish_number/1)
  end

  def parse_snailfish_number(line) do
    case Jason.decode(line) do
      {:ok, [_ | _] = value} -> value
      _ -> raise "Parsed value was not an array"
    end
  end

  def add(num1, num2) do
    [num1, num2]
    |> reduce
  end

  def magnitude([left, right]) do
    3 * magnitude(left) + 2 * magnitude(right)
  end

  def magnitude(number), do: number

  def reduce(tree) do
    case check_for_explosion(tree, 0) do
      {:explode, tree, _leftover} ->
        reduce(tree)

      {:ok, tree} ->
        case check_for_split(tree) do
          {:split, tree} -> reduce(tree)
          {:ok, tree} -> tree
        end
    end
  end

  def check_for_split([left, right]) do
    case check_for_split(left) do
      {:split, new_left} ->
        {:split, [new_left, right]}

      {:ok, ^left} ->
        case check_for_split(right) do
          {:split, new_right} -> {:split, [left, new_right]}
          {:ok, ^right} -> {:ok, [left, right]}
        end
    end
  end

  def check_for_split(num) when num >= 10, do: {:split, [div(num, 2), ceil(num / 2)]}
  def check_for_split(num), do: {:ok, num}

  def check_for_explosion([left, right], 4), do: {:explode, 0, [left, right]}

  def check_for_explosion([left, right], depth) do
    case check_for_explosion(left, depth + 1) do
      {:explode, new_left, [x, y]} ->
        {:explode, [new_left, explode_rightwards(right, y)], [x, nil]}

      {:ok, ^left} ->
        case check_for_explosion(right, depth + 1) do
          {:explode, new_right, [x, y]} ->
            {:explode, [explode_leftwards(left, x), new_right], [nil, y]}

          {:ok, ^right} ->
            {:ok, [left, right]}
        end
    end
  end

  def check_for_explosion(val, _), do: {:ok, val}

  def explode_rightwards(tree, nil), do: tree
  def explode_rightwards([left, right], val), do: [explode_rightwards(left, val), right]
  def explode_rightwards(leaf, val), do: leaf + val

  def explode_leftwards(tree, nil), do: tree
  def explode_leftwards([left, right], val), do: [left, explode_leftwards(right, val)]
  def explode_leftwards(leaf, val), do: leaf + val
end
