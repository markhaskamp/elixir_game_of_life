
defmodule World do

  def init do
    Agent.start_link fn -> [] end, name: __MODULE__
  end

  def init(cells) do
    Agent.start_link fn -> cells end, name: __MODULE__
  end

  def add_cell(cell) do
    Agent.update(__MODULE__, fn list -> [cell | list] end)
  end

  def inspect do
    Agent.get(__MODULE__, fn list -> list end)
  end


  def empty? do
    my_list = Agent.get(__MODULE__, fn list -> list end)
    Enum.count(my_list) == 0
  end

  def get_neighbors_for cell do
    x = elem(cell,0)
    y = elem(cell,1)

    for i <- x-1..x+1 do
      for j <- y-1..y+1, (i != x or j != y) do
        {i,j}
      end
    end

    |>
    List.flatten
  end

end

