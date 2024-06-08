defmodule TestingEctoTest do
  use ExUnit.Case
  doctest TestingEcto

  test "greets the world" do
    assert TestingEcto.hello() == :world
  end
end
