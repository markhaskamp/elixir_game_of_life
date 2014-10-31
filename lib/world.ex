
defmodule World do

  use GenServer

  def start_link,               do: GenServer.start_link(__MODULE__, [], name: __MODULE__)
  def start_link(initial_list), do: GenServer.start_link(__MODULE__, initial_list, name: __MODULE__)

  # public api
  def add_cell(cell), do: GenServer.cast(__MODULE__, {:add_cell, cell})
  def empty?,         do: GenServer.call(__MODULE__, :empty?)

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
    alive_cells = GenServer.call(__MODULE__, :alive_cells)

    get_neighbors_for(cell)
    |>
    Enum.filter(&(Enum.member?(alive_cells, &1)))
  end

  def get_dead_neighbors_for(cell) do
    alive_cells = GenServer.call(__MODULE__, :alive_cells)

    get_neighbors_for(cell)
    |>
    Enum.filter(&(Enum.member?(alive_cells, &1) == false))
  end

  def react_to_tick do
    alive_cells = GenServer.call(__MODULE__, :alive_cells)
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



  # GenServer implementation
  def handle_cast({:add_cell, cell}, state) do
    {:noreply, [cell | state]}
  end

  def handle_call(:empty?, _from, alive_cells) do
    {:reply, Enum.count(alive_cells) == 0, alive_cells}
  end

  def handle_call(:alive_cells, _from, alive_cells) do
    {:reply, alive_cells, alive_cells}
  end


end

