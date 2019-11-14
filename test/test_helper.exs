ExUnit.start(exclude: [:skip])

defmodule RoverAssertions do
  use ExUnit.Case

  def assert_rover(rover, position, direction, status) do
    assert rover.position == position
    assert rover.direction == direction
    assert rover.status == status
  end
end
