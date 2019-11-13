defmodule SimulatorTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

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

    assert first.position == {2, 3}
    assert first.direction == "W"
    assert first.status == :active

    assert second.position == {1, 0}
    assert second.direction == "S"
    assert second.status == :lost
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

    assert first.position == {0, 1}
    assert first.direction == "W"
    assert first.status == :lost

    assert second.position == {4, 5}
    assert second.direction == "E"
    assert second.status == :lost

    assert third.position == {2, 0}
    assert third.direction == "S"
    assert third.status == :active
  end

  test "simulate single rover with valid input" do
    rover = Simulator.simulate({4, 8}, {Rover.new({2, 3}, "N"), "FLLFR"})
    assert rover.position == {2, 3}
    assert rover.direction == "W"
    assert rover.status == :active

    rover = Simulator.simulate({4, 8}, {Rover.new("1", "0", "S"), "FFRLF"})
    assert rover.position == {1, 0}
    assert rover.direction == "S"
    assert rover.status == :lost
  end
end
