defmodule Day18 do
  def run(input_file_name) do
    load_input(input_file_name)
    |> Enum.reduce(&add(&2, &1))
  end

  def load_input(file_name) do
    File.read!("lib/day18/#{file_name}.txt")
    |> String.split(~r/\R/)
    |> Enum.map(&parse_smallfish_number/1)
  end

  def parse_smallfish_number(line) do
    case Jason.decode(line) do
      {:ok, [_ | _] = value} -> value
      _ -> raise "Parsed value was not an array"
    end
  end

  def add(num1, num2) do
    [num1, num2]
    |> reduce
  end

  def reduce(tree) do
    case check_for_explosion(tree, 0) do
      {:explode, tree} ->
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

  def check_for_explosion([_, _], 4), do: {:explode, 0}

  def check_for_explosion([left, right], depth) do
    case check_for_explosion(left, depth + 1) do
      {:explode, new_left} ->
        {:explode, [new_left, right]}

      {:ok, ^left} ->
        case check_for_explosion(right, depth + 1) do
          {:explode, new_right} -> {:explode, [left, new_right]}
          {:ok, ^right} -> {:ok, [left, right]}
        end
    end
  end

  def check_for_explosion(val, _), do: {:ok, val}
end
