defmodule RoverTest do
  use ExUnit.Case
  import RoverAssertions

  test "creation of new rover with valid args" do
    rover = Rover.new({0, 0}, "N")
    assert_rover(rover, {0, 0}, "N", :active)

    another_rover = Rover.new({0, 5}, "S")
    assert_rover(another_rover, {0, 5}, "S", :active)
  end

  test "creation of new rover with valid all string args" do
    rover = Rover.new("0", "5", "N")
    assert_rover(rover, {0, 5}, "N", :active)
  end

  test "change of rover status" do
    rover = Rover.new({0, 0}, "N")
    assert rover.status == :active

    rover = Rover.lost(rover)
    assert_rover(rover, {0, 0}, "N", :lost)
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
    assert_rover(rover, {0, 1}, "N", :active)

    rover = Rover.new({3, 5}, "S")
    rover = Rover.move(rover, "F")
    assert_rover(rover, {3, 4}, "S", :active)

    rover = Rover.new({6, 2}, "W")
    rover = Rover.move(rover, "F")
    assert_rover(rover, {5, 2}, "W", :active)

    rover = Rover.new({6, 8}, "E")
    rover = Rover.move(rover, "F")
    assert_rover(rover, {7, 8}, "E", :active)
  end

  test "active rover rotate right with valid instructions" do
    rover = Rover.new({3, 7}, "N")
    rover = Rover.move(rover, "R")
    assert_rover(rover, {3, 7}, "E", :active)

    rover = Rover.move(rover, "R")
    assert_rover(rover, {3, 7}, "S", :active)

    rover = Rover.move(rover, "R")
    assert_rover(rover, {3, 7}, "W", :active)

    rover = Rover.move(rover, "R")
    assert_rover(rover, {3, 7}, "N", :active)
  end

  test "active rover rotate left with valid instructions" do
    rover = Rover.new({3, 7}, "N")
    rover = Rover.move(rover, "L")
    assert_rover(rover, {3, 7}, "W", :active)

    rover = Rover.move(rover, "L")
    assert_rover(rover, {3, 7}, "S", :active)

    rover = Rover.move(rover, "L")
    assert_rover(rover, {3, 7}, "E", :active)

    rover = Rover.move(rover, "L")
    assert_rover(rover, {3, 7}, "N", :active)
  end

  test "rover move with invalid instructions" do
    rover = Rover.new({5, 7}, "N")
    assert Rover.move(rover, "A") == {:error, "invalid_movement_instruction"}
  end
end
