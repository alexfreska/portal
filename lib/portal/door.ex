defmodule Portal.Door do

  @doc """
  Initializes Agent for storing list.
  """
  def start_link(color) do
    Agent.start_link(fn -> [] end, name: color)
  end

  @doc """
  Gets list of data stored in `door`.
  """
  def get(door) do
    Agent.get(door, fn list -> list end)
  end

  @doc """
  Adds `item` to list of data stored in `door`.
  """
  def put(door,item) do
    Agent.update(door, fn list -> [item | list] end)
  end

  @doc """
  Pops off the list of data stored in `door`.
  """
  def pop(door) do
    Agent.get_and_update(door, fn
      []      -> {:error, []}
      [h|t]   -> {{:ok, h}, t}
    end)
  end

end
