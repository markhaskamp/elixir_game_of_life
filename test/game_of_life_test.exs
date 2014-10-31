defmodule GameOfLifeTest do
  use ExUnit.Case

  test "a new World, started with no parameter, has no alive cells" do
    World.start_link
    assert World.empty?
  end

  test "a new World can be started with a initial list of alive cells" do
    World.start_link [{1,1}]
    assert World.empty? == false
  end

  test "add_cell adds cell" do
    World.start_link
    assert World.empty?
    World.add_cell({1,1})
    assert World.empty? == false
  end

  test "get neighbors for {0,0}" do
     neighbors = World.get_neighbors_for {0,0}
     assert Enum.sort(neighbors) == Enum.sort([{1,0}, {0,1}, {1,1}])
   end

  test "get alive neighbors for a cell" do
     World.start_link [{1,1}, {2,1}, {3,1}]
     assert World.get_alive_neighbors_for({1,1}) == [{2,1}]
     assert World.get_alive_neighbors_for({2,1}) == [{1,1}, {3,1}]
     assert World.get_alive_neighbors_for({3,1}) == [{2,1}]
   end

  test "get dead neighbors for a cell" do
    World.start_link [{1,1}, {2,1}, {3,1}, {1,2}]
    assert Enum.sort(World.get_dead_neighbors_for({1,1})) == Enum.sort([{0, 0}, {0, 1}, {0, 2}, {1, 0}, {2, 0}, {2, 2}])
    assert Enum.sort(World.get_dead_neighbors_for({2,1})) == Enum.sort([{1, 0}, {2, 0}, {2, 2}, {3, 0}, {3, 2}])
    assert Enum.sort(World.get_dead_neighbors_for({3,1})) == Enum.sort([{2, 0}, {2, 2}, {3, 0}, {3, 2}, {4, 0}, {4, 1}, {4, 2}])
  end

  test "get cells to remain alive" do
    World.start_link [{1,1}, {2,1}, {3,1}]
    assert World.get_cells_to_remain_alive([{1,1}, {2,1}, {3,1}]) == [{2,1}]
  end

  test "react to tick" do
    World.start_link [{1,1}, {2,1}, {3,1}, {1,2}, {8,8}]
    new_cells = World.react_to_tick
    assert Enum.sort(new_cells) == Enum.sort([{1, 1}, {1, 2}, {2, 0}, {2, 1}])
  end

  test "also react to tick" do
    World.start_link [{1,1}, {2,1}, {3,1}, {1,2}, {3,0}, {3,2}]
    new_cells = World.react_to_tick
    assert Enum.count(new_cells) == 6
    assert Enum.member?(new_cells, {3,0}) == true
    assert Enum.member?(new_cells, {1,1}) == true
    assert Enum.member?(new_cells, {3,1}) == true
    assert Enum.member?(new_cells, {4,1}) == true
    assert Enum.member?(new_cells, {1,2}) == true
    assert Enum.member?(new_cells, {3,2}) == true
    assert Enum.member?(new_cells, {2,1}) == false
  end
end
