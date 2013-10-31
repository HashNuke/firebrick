defmodule Rinket.Smtp do

  def start_link do
    session_options = [callbackoptions: [parse: true] ]
    :gen_smtp_server.start(Rinket.SmtpHandler, [[port: 2525, sessionoptions: session_options]])
  end


  def send_test_mail() do
    host = :net_adm.localhost
    sender = "rinket_rambler@#{host}"
    recepients = ["john@#{host}"]
    sender_address = "Rinker Rambler <rinket_rambler@#{host}>"
    recepient_addresses = ["John Appleseed <john@#{host}>"]
    client_options = [relay: host, username: sender, password: "mypassword", port: 2525]
    mail = {
            sender,
            recepients,
            "Subject: Ahoy Matey\r\nFrom: #{sender_address} \r\nTo: #{hd(recepient_addresses)} \r\n\r\nThis is the email body"
           }

    :gen_smtp_client.send(mail, client_options)
  end
end
