defmodule Firebrick.SmtpServer do

  def start_link do
    session_options = [callbackoptions: [parse: true] ]
    :gen_smtp_server.start(Firebrick.SmtpHandler, [[port: 2525, sessionoptions: session_options]])
  end

end
