defmodule KgbTest do
  use ExUnit.Case
  doctest Kgb

  test "greets the world" do
    assert Kgb.hello() == :world
  end
end
