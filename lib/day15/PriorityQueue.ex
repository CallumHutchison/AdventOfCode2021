defmodule PriorityQueue do
  def new do
    []
  end

  def add([], value) do
    [value]
  end

  def add(queue, value) do
    if value < hd(queue) do
      [value | queue]
    else
      [hd(queue)] ++ add(tl(queue), value)
    end
  end

  def add([], value, _transform) do
    [value]
  end

  def add(queue, value, transform) do
    if transform.(value) < transform.(hd(queue)) do
      [value | queue]
    else
      [hd(queue)] ++ add(tl(queue), value, transform)
    end
  end

  def pop([head | tail]) do
    {head, tail}
  end

  def remove(queue, filter) do
    Enum.filter(queue, filter)
  end
end
