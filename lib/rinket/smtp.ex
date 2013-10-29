defmodule Rinket.Smtp do

  def start_link do
    session_options = [callbackoptions: [parse: true] ]
    :gen_smtp_server.start(Rinket.SmtpHandler, [[port: 2525, sessionoptions: session_options]])
  end


  def send_test_mail() do
    host = :net_adm.localhost
    sender = "rinket_rambler@#{host}"
    recepients = ["john@#{host}"]
    client_options = [relay: host, username: sender, password: "mypassword", port: 2525]
    mail = {
            sender,
            recepients,
            "Subject: Ahoy Matey\r\nFrom: Rinket Rambler \r\nTo: John Appleseed \r\n\r\nThis is the email body"
           }

    :gen_smtp_client.send(mail, client_options)
  end
end
