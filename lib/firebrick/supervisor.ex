defmodule Firebrick.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end


  def init([]) do
    children = [
      worker(Firebrick.DynamoSupervisor, [], restart: :temporary),
      worker(Firebrick.RiakSupervisor, [], restart: :temporary),
      worker(Firebrick.Smtp, [], restart: :temporary)
    ]

    supervise(children, strategy: :one_for_one)
  end
end
