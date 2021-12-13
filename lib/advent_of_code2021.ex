defmodule AdventOfCode2021 do
  @solutions [
    %{day: "01", title: "Sonar Sweep", function: nil},
    %{day: "02", title: "Dive!", function: &Day02.run(&1)},
    %{day: "03", title: "Binary Diagnostic", function: nil},
    %{day: "04", title: "Giant Squid", function: &Day04.run(&1)},
    %{day: "05", title: "Hydrothermal Venture", function: &Day05.run(&1)},
    %{day: "06", title: "Lanternfish", function: &Day06.run(&1)},
    %{day: "07", title: "The Treachery of Whales", function: &Day07.run(&1)},
    %{day: "08", title: "Seven Segment Search", function: &Day08.run(&1)},
    %{day: "09", title: "Smoke Basin", function: &Day09.run(&1)},
    %{day: "10", title: "Syntax Scoring", function: &Day10.run(&1)},
    %{day: "11", title: "Dumbo Octopus", function: &Day11.run(&1)},
    %{day: "12", title: "Passage Pathing", function: &Day12.run(&1)}
  ]

  @table_mapping [
    {"Day", :day},
    {"Title", :title},
    {"Part 1 Answer", :part1},
    {"Part 2 Answer", :part2},
    {"Total execution time (s)", :time}
  ]

  def run do
    @solutions
    |> Enum.map(&Task.async(fn -> time_task(&1) end))
    |> Enum.map(&Task.await/1)
    |> Scribe.print(data: @table_mapping)

    :ok
  end

  defp time_task(%{day: day, title: title, function: nil}) do
    %{day: day, title: title, part1: "n/a", part2: "n/a", time: "n/a"}
  end

  defp time_task(%{day: day, title: title, function: function}) do
    {time, {part1, part2}} = :timer.tc(function, ["input"])
    %{day: day, title: title, part1: part1, part2: part2, time: time / 1_000_000}
  end
end
