defmodule PhzxTest do
  use ExUnit.Case
  doctest Phzx

  test "escape_velocity(:earth)" do
      assert Phxz.Rocketry.escape_velocity(:earth) == 11.2
  end

  test "escape_velocity(:mars)" do
      assert Phxz.Rocketry.escape_velocity(:mars) == 5.1
  end

  test "escape_velocity(:moon)" do
      assert Phxz.Rocketry.escape_velocity(:moon) == 2.4
  end

  test "orbital_acceleration/1" do
    assert Phxz.Rocketry.orbital_acceleration(100) == 9.512678810620692
  end

  test "orbital_term/1" do
    assert Phxz.Rocketry.orbital_term(100) == 1328495384991379500.0
  end

end
