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

end
