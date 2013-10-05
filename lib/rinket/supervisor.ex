defmodule Rinket.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end


  def init([]) do
    dynamo_options = [max_restarts: 5, max_seconds: 5]

    children = [
      worker(Rinket.Dynamo, [dynamo_options]),
      worker(RiakPool, ['127.0.0.1', 8087])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
