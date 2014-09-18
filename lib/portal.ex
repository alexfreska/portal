defmodule Portal do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Portal.Door, [])
    ]

    opts = [strategy: :simple_one_for_one, name: Portal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Starts new `Portal.Door` under identified `color` in supervision tree.
  """
  def shoot(color) do
    Supervisor.start_child(Portal.Supervisor, [color])
  end

  defstruct [:left, :right]

  @doc """
  Returns portal struct with provided `left` and `right` portals.
  Initializes `left` with provided `data`.
  """
  def transfer(left, right, data) do
    for item <- data do
      Portal.Door.put(left, item)
    end

    %Portal{left: left, right: right}

  end

  @doc """
  Automation function, belongs in ExUnit.
  """
  def quick do

    shoot(:blue)
    shoot(:green)

    transfer(:blue,:green,[1,2,3,4,5])
    |> push_right
    |> push_right
    |> push_right
    |> push_left

  end

  @doc """
  Pushes data to the right in provided `portal` instance.
  """
  def push_right(portal) do
    case Portal.Door.pop(portal.left) do
      {:error} -> :ok
      {:ok,h} -> Portal.Door.put(portal.right,h)
    end
    portal
  end

  @doc """
  Pushes data to the left in provided `portal` instance.
  """
  def push_left(portal) do
    case Portal.Door.pop(portal.right) do
      {:error} -> :ok
      {:ok,h} -> Portal.Door.put(portal.left,h)
    end
    portal
  end

  @doc """
  Implement new inspect for Portal to logically display portal interaction.
  """
  defimpl Inspect, for: Portal do
    def inspect(%Portal{left: left, right: right}, _) do

      left_door   = inspect(left)
      right_door  = inspect(right)

      left_data   = inspect(Enum.reverse(Portal.Door.get(left)))
      right_data  = inspect(Portal.Door.get(right))

      max = max(String.length(left_door), String.length(left_data))

      """
      #Portal<
        #{String.rjust(left_door, max)} <=> #{right_door}
        #{String.rjust(left_data, max)} <=> #{right_data}
      >
      """
    end
  end
end
