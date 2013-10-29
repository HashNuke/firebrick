defmodule Rinket.Smtp do

  def start_link do
    :gen_smtp_server.start(:smtp_server_example, [[port: 2525]])
  end


  def send_test_mail() do
    {:ok, hostname} = :inet.gethostname
    host = "#{hostname}.local"
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
