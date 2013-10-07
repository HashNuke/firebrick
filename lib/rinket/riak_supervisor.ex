defmodule Rinket.RiakSupervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end


  def init([]) do
    children = [
      worker(RiakPool, ['127.0.0.1', 8087], restart: :transient)
    ]

    supervise(children, strategy: :one_for_one, restart: :transient)
  end
end
