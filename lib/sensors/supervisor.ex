# a simple supervisor that starts up the Scenic.SensorPubSub server
# and any set of other sensor processes

defmodule Example.Sensors.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      Example.Sensors.Temperature
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
