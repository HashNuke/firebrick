defmodule Firebrick.SmtpServer do

  def start_link do
    session_options = [callbackoptions: [parse: true] ]
    :gen_smtp_server.start(Firebrick.SmtpHandler, [[port: 2525, sessionoptions: session_options]])
  end


  def send_test_mail() do
    host = :net_adm.localhost
    sender = "firebrick_tester@#{host}"
    recepients = ["admin@#{host}", "someone@#{host}"]
    sender_address = "Firebrick Tester <firebrick_tester@#{host}>"
    recepient_addresses = ["Admin <admin@#{host}>", "Someone <someone@#{host}>"]
    client_options = [relay: host, username: sender, password: "mypassword", port: 2525]
    mail = {
      sender,
      recepients,
      "Subject: Ahoy Matey\r\nFrom: #{sender_address} \r\nTo: #{hd(recepient_addresses)} \r\n\r\nMy name is Jack Sparrow"
    }

    :gen_smtp_client.send(mail, client_options)
  end
end
