defmodule AdventOfCode2021 do
  @solutions [
    %{day: "01", title: "Sonar Sweep", function: &Day11.run(&1)},
    %{day: "02", title: "Dive!", function: &Day11.run(&1)},
    %{day: "03", title: "Binary Diagnostic", function: &Day11.run(&1)},
    %{day: "04", title: "Giant Squid", function: &Day11.run(&1)},
    %{day: "05", title: "Hydrothermal Venture", function: &Day11.run(&1)},
    %{day: "06", title: "Lanternfish", function: &Day11.run(&1)},
    %{day: "07", title: "The Treachery of Whales", function: &Day11.run(&1)},
    %{day: "08", title: "Seven Segment Search", function: &Day08.run(&1)},
    %{day: "09", title: "Smoke Basin", function: &Day09.run(&1)},
    %{day: "10", title: "Syntax Scoring", function: &Day10.run(&1)},
    %{day: "11", title: "Dumbo Octopus", function: &Day11.run(&1)},
    %{day: "12", title: "Passage Pathing", function: &Day12.run(&1)}
  ]

  def run do
    @solutions
    |> Enum.map(&Task.async(fn -> time_task(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.reduce(&(&2 <> "\n" <> &1))
    |> IO.puts()

    :ok
  end

  defp time_task(%{day: day, title: title, function: function}) do
    {time, {part1, part2}} = :timer.tc(function, ["input"])
    "#{day}: #{title} \t\t| Part 1: #{part1} \t\t| Part 2: #{part2} \t\t| #{time / 1_000_000}s"
  end
end
