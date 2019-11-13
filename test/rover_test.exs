defmodule RoverTest do
  use ExUnit.Case

  test "creation of new rover with valid args" do
    rover = Rover.new({0, 0}, "N")
    assert rover.position == {0, 0}
    assert rover.direction == "N"
    assert rover.status == :active

    another_rover = Rover.new({0, 5}, "S")
    assert another_rover.position == {0, 5}
    assert another_rover.direction == "S"
    assert another_rover.status == :active
  end

  test "creation of new rover with valid all string args" do
    rover = Rover.new("0", "5", "N")
    assert rover.position == {0, 5}
    assert rover.direction == "N"
    assert rover.status == :active
  end

  test "change of rover status" do
    rover = Rover.new({0, 0}, "N")
    assert rover.status == :active

    rover = Rover.lost(rover)
    assert rover.position == {0, 0}
    assert rover.direction == "N"

    assert rover.status == :lost
  end

  test "creation of new rover with invalid args" do
    invalid_position = {:error, "invalid_position"}
    invalid_direction = {:error, "invalid_direction"}

    assert Rover.new({-3, 5}, "N") == invalid_position
    assert Rover.new("a", "N") == invalid_position

    assert Rover.new({0, 0}, "X") == invalid_direction
    assert Rover.new({3, 8}, 12) == invalid_direction
  end

  test "active rover forward movement with valid instructions" do
    rover = Rover.new({0, 0}, "N")
    rover = Rover.move(rover, "F")
    assert rover.direction == "N"
    assert rover.position == {0, 1}
    assert rover.status == :active

    rover = Rover.new({3, 5}, "S")
    rover = Rover.move(rover, "F")
    assert rover.direction == "S"
    assert rover.position == {3, 4}
    assert rover.status == :active

    rover = Rover.new({6, 2}, "W")
    rover = Rover.move(rover, "F")
    assert rover.direction == "W"
    assert rover.position == {5, 2}
    assert rover.status == :active

    rover = Rover.new({6, 8}, "E")
    rover = Rover.move(rover, "F")
    assert rover.direction == "E"
    assert rover.position == {7, 8}
    assert rover.status == :active
  end

  test "active rover rotate right with valid instructions" do
    rover = Rover.new({3, 7}, "N")
    rover = Rover.move(rover, "R")
    assert rover.position == {3, 7}
    assert rover.direction == "E"
    assert rover.status == :active

    rover = Rover.move(rover, "R")
    assert rover.position == {3, 7}
    assert rover.direction == "S"
    assert rover.status == :active

    rover = Rover.move(rover, "R")
    assert rover.position == {3, 7}
    assert rover.direction == "W"
    assert rover.status == :active

    rover = Rover.move(rover, "R")
    assert rover.position == {3, 7}
    assert rover.direction == "N"
    assert rover.status == :active
  end

  test "active rover rotate left with valid instructions" do
    rover = Rover.new({3, 7}, "N")
    rover = Rover.move(rover, "L")
    assert rover.position == {3, 7}
    assert rover.direction == "W"
    assert rover.status == :active

    rover = Rover.move(rover, "L")
    assert rover.position == {3, 7}
    assert rover.direction == "S"
    assert rover.status == :active

    rover = Rover.move(rover, "L")
    assert rover.position == {3, 7}
    assert rover.direction == "E"
    assert rover.status == :active

    rover = Rover.move(rover, "L")
    assert rover.position == {3, 7}
    assert rover.direction == "N"
    assert rover.status == :active
  end

  test "rover move with invalid instructions" do
    rover = Rover.new({5, 7}, "N")
    assert Rover.move(rover, "A") == {:error, "invalid_movement_instruction"}
  end
end
