defmodule WorldTest do
  use ExUnit.Case

  import World

  test "a new world is an empty world" do
    World.init
    assert World.empty?
  end

  test "can init a world with a list of alive cells" do
    World.init [{1,1}, {2,1}, {3,1}]
    assert World.empty? == false
  end

end
