defmodule Simulator do
  def simulate(input) do
    [grid_dimensions_input | rover_input] = String.split(input, "\n")

    grid = parse_grid_dimensions(grid_dimensions_input)

    rover_input
    |> Enum.map(&parse_rover_input/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&simulate(grid, &1))
  end

  defp parse_grid_dimensions(input) do
    input
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def simulate(grid, {rover, instructions}) do
    instructions
    |> String.graphemes()
    |> Enum.reduce_while(rover, &move_and_check(grid, &1, &2))
    |> IO.inspect()
  end

  defp move_and_check(grid, ins, rover) do
    moved = Rover.move(rover, ins)

    if(check_boundries(grid, moved.position)) do
      {:cont, moved}
    else
      {:halt, Rover.lost(rover)}
    end
  end

  defp check_boundries({grid_x, grid_y}, {rov_x, rov_y})
       when grid_x > rov_x and grid_y > rov_y and rov_y >= 0 and rov_x >= 0,
       do: true

  defp check_boundries(_, _), do: false

  @rover_input_regex ~r/^\((?<pos_x>[0-9]+), (?<pos_y>[0-9]+), (?<direction>[N|E|W|S]{1})\) (?<ins>[F|L|R]+)$/
  defp parse_rover_input(input_line) do
    case Regex.named_captures(@rover_input_regex, input_line) do
      nil -> nil
      c -> {Rover.new(c["pos_x"], c["pos_y"], c["direction"]), c["ins"]}
    end
  end
end
