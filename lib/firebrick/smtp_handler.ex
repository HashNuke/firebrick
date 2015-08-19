defmodule Firebrick.SmtpHandler do
  @behaviour :gen_smtp_server_session

  defmodule State do
    defstruct options: []
  end


  require Logger
  alias Firebrick.Mail
  alias Firebrick.Mail.Utils
  alias Firebrick.Services


  @type error_message :: {:error, String.t, State.t}

  # SMTP error codes
  @smtp_too_busy 421
  @smtp_requested_action_okay 250
  @smtp_mail_action_abort 552
  @smtp_unrecognized_command 500


  @doc """
  Every time a mail arrives, a process is started to handle it.
  The init/4 function accepts the following args
    * hostname - the SMTP server's hostname
    * session_count - number of mails currently being handled
    * client_ip_address - IP address of the client
    * options - the `callbackoptions` passed to `:gen_smtp_server.start/2`

  Return
    * `{:ok, banner, state}` - to send `banner` to client and initializes session with `state`
    * `{:stop, reason, message}` - to exit session with `reason` and send `message` to client
  """
  @spec init(binary, non_neg_integer, tuple, list) :: {:ok, String.t, State.t} | {:stop, any, String.t}
  def init(hostname, _session_count, _client_ip_address, options) do
    banner = [hostname, " ESMTP mail-to-json server"]
    state  = %State{options: options}
    {:ok, banner, state}
  end


  @doc """
  Handshake with the client
    * Return `{:ok, max_message_size, state}` if we handle the hostname
      ```
      # max_message_size should be an integer
      # For 10kb max size, the return value would look like this
      {:ok, 1024 * 10, state}
      ```
    * Return `{:error, error_message, state}` if we don't handle mail for the hostname
      ```
      # error_message must be prefixed with standard SMTP error code
      # looks like this
      554 invalid hostname
      554 Dear human from Sector-8614 we don't handle mail for this domain name
      ```
  """
  @spec handle_HELO(binary, State.t) :: {:ok, pos_integer, State.t} | {:ok, State.t} | error_message
  def handle_HELO(hostname, state) do
    :io.format("#{@smtp_requested_action_okay} HELO from #{hostname}~n")
    {:ok, 655360, state} # we'll say 640kb of max size
  end


  @spec handle_EHLO(binary, list, State.t) :: {:ok, list, State.t} | error_message
  def handle_EHLO(_hostname, extensions, state) do
    {:ok, extensions, state}
  end


  @doc "Accept or reject mail to incoming addresses here"
  @spec handle_MAIL(binary, State.t) :: {:ok, State.t} | error_message
  def handle_MAIL(sender, state) do

    #TODO look into this.
    # Do we send a bounce notice email later about non-existent user
    # OR reveal it right away?
    case Services.Identity.find_by_address(sender) do
      nil ->
        {:error, "No user found", state}

      identity ->
        new_options = Keyword.put state.options, :identity, identity
        new_state = %{state | options: new_options}
        {:ok, new_state}
    end
  end


  @doc "Accept receipt of mail to an email address or reject it"
  @spec handle_RCPT(binary(), State.t) :: {:ok, State.t} | {:error, String.t, State.t}
  def handle_RCPT(_to, state) do
    {:ok, state}
  end


  @doc """
  Verify incoming address.
  This I heard, was a security issue since people were able to check which accounts existed on the system. We'll just say yes to all incoming addresses.
  """
  @spec handle_VRFY(binary, State.t) :: {:ok, String.t, State.t} | {:error, String.t, State.t}
  def handle_VRFY(user, state) do
    {:ok, "#{user}@#{:smtp_util.guess_FQDN()}", state}
  end


  @doc "Handle mail data. This includes subject, body, etc"
  @spec handle_DATA(binary, [binary,...], binary, State.t) :: {:ok, String.t, State.t} | {:error, String.t, State.t}
  def handle_DATA(_from, _to, "", state) do
    {:error, "#{@smtp_mail_action_abort} Message too small", state}
  end


  def handle_DATA(from, to, data, state) do
    unique_id = Utils.create_unique_id()

    Logger.debug("Mail from #{from} to [#{Enum.join to, ", "}] with body length #{byte_size(data)} queued as #{unique_id}")

    mail = process_mail(data, state, unique_id)
    {:ok, unique_id, state}
  end


  @doc "Reset internal state"
  @spec handle_RSET(State.t) :: State.t
  def handle_RSET(state) do
    state
  end


  @doc "No other SMTP verbs are recognized"
  @spec handle_other(binary, binary, State.t) :: {String.t, State.t}
  def handle_other(verb, _args, state) do
    {["#{@smtp_unrecognized_command} Error: command not recognized : '", verb, "'"], state}
  end


  @spec terminate(any, State.t) :: {:ok, any, State.t}
  def terminate(reason, state) do
    {:ok, reason, state}
  end


  defp process_mail(raw_data, state, unique_id) do
    identity = get_in state, [:options][:identity]
    try do
      # :mimemail.decode/1 is provided by gen_smtp
      :mimemail.decode(raw_data)
      |> Mail.Parser.parse
      |> Services.Mail.save(unique_id, identity)
    rescue
      reason ->
        :io.format("Message decode FAILED with ~p:~n", [reason])
    end
  end

end
