
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

end

