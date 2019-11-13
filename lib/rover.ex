defmodule Rover do
  defstruct position: {0, 0}, direction: "N", status: :active

  def new(position, direction) do
    with :ok <- validate_position(position),
         :ok <- validate_direction(direction),
         do: %Rover{position: position, direction: direction}
  end

  def new(pos_x, pos_y, direction),
    do: new({String.to_integer(pos_x), String.to_integer(pos_y)}, direction)

  def lost(rover), do: %Rover{rover | status: :lost}

  defp validate_position({x, y} = _position)
       when is_integer(x) and is_integer(y) and x >= 0 and y >= 0,
       do: :ok

  defp validate_position(_), do: {:error, "invalid_position"}

  defp validate_direction(direction) when direction in ["S", "N", "W", "E"], do: :ok
  defp validate_direction(_), do: {:error, "invalid_direction"}

  def move(%Rover{position: {x, y}, direction: "N"} = rover, "F"),
    do: %Rover{rover | position: {x, y + 1}}

  def move(%Rover{position: {x, y}, direction: "S"} = rover, "F"),
    do: %Rover{rover | position: {x, y - 1}}

  def move(%Rover{position: {x, y}, direction: "E"} = rover, "F"),
    do: %Rover{rover | position: {x + 1, y}}

  def move(%Rover{position: {x, y}, direction: "W"} = rover, "F"),
    do: %Rover{rover | position: {x - 1, y}}

  def move(%Rover{direction: "S"} = rover, "R"), do: %Rover{rover | direction: "W"}
  def move(%Rover{direction: "N"} = rover, "R"), do: %Rover{rover | direction: "E"}
  def move(%Rover{direction: "W"} = rover, "R"), do: %Rover{rover | direction: "N"}
  def move(%Rover{direction: "E"} = rover, "R"), do: %Rover{rover | direction: "S"}

  def move(%Rover{direction: "S"} = rover, "L"), do: %Rover{rover | direction: "E"}
  def move(%Rover{direction: "N"} = rover, "L"), do: %Rover{rover | direction: "W"}
  def move(%Rover{direction: "W"} = rover, "L"), do: %Rover{rover | direction: "S"}
  def move(%Rover{direction: "E"} = rover, "L"), do: %Rover{rover | direction: "N"}

  def move(_, _), do: {:error, "invalid_movement_instruction"}
end

defimpl Inspect, for: Rover do
  def inspect(%Rover{position: {pos_x, pos_y}, direction: direction, status: status}, _opts) do
    "(#{pos_x}, #{pos_y}, #{direction})" <>
      case status do
        :lost -> " LOST"
        _ -> ""
      end
  end
end
