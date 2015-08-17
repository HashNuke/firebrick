defmodule Firebrick do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Firebrick.Endpoint, []),
      # Start the Ecto repository
      worker(Firebrick.Repo, [])
      # Here you could define other workers and supervisors as children
      # worker(Firebrick.Worker, [arg1, arg2, arg3]),
    ]

    # start web server only if Phoenix is serving endpoints
    if Application.get_env(:phoenix, :serve_endpoints) do
      children = children ++ [worker(Firebrick.SmtpServer, [])]
    end

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firebrick.Supervisor]
    Supervisor.start_link(children, opts)
  end


  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Firebrick.Endpoint.config_change(changed, removed)
    :ok
  end


  def send_test_mail() do
    host = :net_adm.localhost
    sender_email = "foo@#{host}"
    recipient_emails = ["bar@#{host}", "zoo@#{host}"]
    sender = "Foo Tester <#{sender_email}>"
    recipients = [
      "Bar Tester <#{Enum.at(recipient_emails, 0)}>",
      "Zoo Tester <#{Enum.at(recipient_emails, 1)}>"
    ]
    client_options = [relay: host, username: sender, password: "dummy", port: 2525]
    mail = {
      sender_email,
      recipient_emails,
      "Subject: Ahoy Matey\r\nFrom: #{sender} \r\nTo: #{hd(recipients)} \r\n\r\nMy name is Jack Sparrow"
    }

    :gen_smtp_client.send(mail, client_options)
  end


end
