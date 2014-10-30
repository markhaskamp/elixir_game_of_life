
defmodule World do

  def init do
    Agent.start_link fn -> [] end, name: __MODULE__
  end

  def init(cells) do
    Agent.start_link fn -> cells end, name: __MODULE__
  end


  def empty? do
    my_list = Agent.get(__MODULE__, fn list -> list end)
    Enum.count(my_list) == 0
  end

end

