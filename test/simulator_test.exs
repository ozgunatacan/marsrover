defmodule SimulatorTest do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import RoverAssertions

  test "simluate rovers with valid input" do
    input = """
    4 8
    (2, 3, N) FLLFR
    (1, 0, S) FFRLF
    """

    output = """
    (2, 3, W)
    (1, 0, S) LOST
    """

    # test console output
    assert capture_io(fn -> Simulator.simulate(input) end) == output

    # test data
    [first, second] = Simulator.simulate(input)

    assert_rover(first, {2, 3}, "W", :active)
    assert_rover(second, {1, 0}, "S", :lost)
  end

  # This is my test case
  test "simulate rovers with more valid input" do
    input = """
    5 8
    (0, 0, N) FLFRFF
    (3, 5, S) FLLFRFF
    (2, 2, W) FLFLFRF
    """

    output = """
    (0, 1, W) LOST
    (4, 5, E) LOST
    (2, 0, S)
    """

    # test console output
    assert capture_io(fn -> Simulator.simulate(input) end) == output

    # test data
    [first, second, third] = Simulator.simulate(input)

    assert_rover(first, {0, 1}, "W", :lost)
    assert_rover(second, {4, 5}, "E", :lost)
    assert_rover(third, {2, 0}, "S", :active)
  end

  test "simulate single rover with valid input" do
    rover = Simulator.simulate({4, 8}, {Rover.new({2, 3}, "N"), "FLLFR"})
    assert_rover(rover, {2, 3}, "W", :active)

    rover = Simulator.simulate({4, 8}, {Rover.new("1", "0", "S"), "FFRLF"})
    assert_rover(rover, {1, 0}, "S", :lost)
  end
end
