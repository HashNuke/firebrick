defmodule Rinket.Smtp do

  def start_link do
    :gen_smtp_server.start(:smtp_server_example)
  end

end
