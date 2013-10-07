defmodule Rinket.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end


  def init([]) do
    dynamo_options = [max_restarts: 5, max_seconds: 5]

    children = [
      worker(Rinket.DynamoSupervisor, [], restart: :temporary),
      worker(Rinket.RiakSupervisor, [], restart: :temporary)
    ]

    supervise(children, strategy: :one_for_one, restart: :temporary)
  end
end
