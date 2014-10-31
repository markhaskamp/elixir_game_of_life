defmodule World do

  use GenServer

  def start_link,               do: Agent.start_link(fn -> [] end, name: __MODULE__)
  def start_link(initial_list), do: Agent.start_link(fn -> initial_list end, name: __MODULE__)

  # public api
  def add_cell(cell),  do: Agent.update(__MODULE__, fn(list) -> [cell | list] end)
  def empty?,          do: Agent.get(__MODULE__, fn(list) -> Enum.count(list) == 0 end)
  def get_alive_cells, do: Agent.get(__MODULE__, fn(list) -> list end)

  def get_neighbors_for(cell) do
    x = elem cell,0
    y = elem cell,1
    for i <- x-1..x+1, i >= 0 do
      for j <- y-1..y+1, j >= 0  do
        {i, j}
      end
    end

    |>
    List.flatten

    |>
    Enum.filter(&(&1 != {x,y}))
  end

  def get_alive_neighbors_for(cell) do
    alive_cells = get_alive_cells

    get_neighbors_for(cell)
    |>
    Enum.filter(&(Enum.member?(alive_cells, &1)))
  end

  def get_dead_neighbors_for(cell) do
    alive_cells = get_alive_cells

    get_neighbors_for(cell)
    |>
    Enum.filter(&(Enum.member?(alive_cells, &1) == false))
  end

  def react_to_tick do
    alive_cells = get_alive_cells
    still_alive = get_cells_to_remain_alive(alive_cells)
    zombie_cells = get_cells_to_come_alive(alive_cells)

    Enum.concat(still_alive, zombie_cells)
  end

  def get_cells_to_remain_alive(alive_cells) do
    Enum.filter(alive_cells, fn(t) ->
      count = Enum.count(get_alive_neighbors_for(t))
      count > 1 and count < 4
    end)
  end

  def get_cells_to_come_alive(alive_cells) do
    Enum.map(alive_cells, &(get_dead_neighbors_for(&1)))
    |>
    List.flatten
    |>
    Enum.filter(fn(t) ->
      Enum.count(get_alive_neighbors_for(t)) == 3
    end)
    |>
    uniq
  end

  def uniq(list) do
    Enum.into(list, HashSet.new)
    |>
    Enum.to_list
  end


end

