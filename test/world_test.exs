defmodule WorldTest do
  use ExUnit.Case

  test "a new world is an empty world" do
    World.init
    assert World.empty?
  end

  test "can init a world with a list of alive cells" do
    World.init [{1,1}, {2,1}, {3,1}]
    assert World.empty? == false
  end

  test "can add a cell" do
    World.init
    assert World.empty?

    World.add_cell {1,1}
    assert World.empty? == false
  end

  test "get neighbors for a cell" do
    assert Enum.sort(World.get_neighbors_for({1,1})) == 
           Enum.sort([{0,0}, {1,0}, {2,0}, {0,1}, {2,1}, {0,2}, {1,2}, {2,2}])
  end

  test "get neighbors for a cell, board is 2d and bounded at 0" do
    assert Enum.sort(World.get_neighbors_for({0,0})) ==
           Enum.sort([{1,0},{0,1},{1,1}])
  end
end
