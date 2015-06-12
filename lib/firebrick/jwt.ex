defmodule Firebrick.Jwt do

  def encode(data, options) do
    encoded_header = %{typ: "JWT", alg: jwt_option(options, :algorithm)}
    |> encode_part

    current_unix_timestamp = current_time
    expiry_unix_timestamp  = current_unix_timestamp + jwt_option(options, :token_validity)

    registered_claims = %{
      iat: current_unix_timestamp,
      exp: expiry_unix_timestamp
    }

    encoded_payload = Map.merge(data, registered_claims)
    |> encode_part

    encoded_signature = signature("#{encoded_header}.#{encoded_payload}", options)
    |> Base.url_encode64

    {:ok, "#{encoded_header}.#{encoded_payload}.#{encoded_signature}"}
  end


  defp encode_part(part) do
    Poison.encode!(part)
    |> Base.url_encode64
  end


  def decode(data, options) do
    [encoded_header, encoded_payload, encoded_signature] = String.split(data, ".")

    if signature_match?(encoded_header, encoded_payload, encoded_signature, options) do
      {:ok, json} = Base.url_decode64(encoded_payload)
      Poison.decode(json)
    else
      {:error, "signature mismatch"}
    end
  end


  defp signature_match?(encoded_header, encoded_payload, encoded_signature, options) do
    {:ok, decoded_signature} = Base.url_decode64(encoded_signature)
    {:ok, header} = Base.url_decode64(encoded_header)
    algorithm = jwt_option(options, :algorithm)

    signature(algorithm, "#{encoded_header}.#{encoded_payload}") == decoded_signature
  end


  #TODO
  # "RS256"
  # "RS384"
  # "RS512"
  # "ES256"
  # "ES384"
  # "ES512"
  defp signature(data, options) do
    algorithm = jwt_option options, :algorithm
    secret = jwt_option options, :secret

    case algorithm do
      "HS256" ->
        :crypto.hmac(:sha256, secret, data)
      "HS384" ->
        :crypto.hmac(:sha384, secret, data)
      "HS512" ->
        :crypto.hmac(:sha512, secret, data)
    end
    |> Base.encode16
  end


  defp current_time do
    {mega_seconds, seconds, __} = :os.timestamp
    # 1 megasecond is one-million seconds
    seconds + (mega_seconds * 1000000)
  end


  def jwt_option(options, opt_name) do
    case opt_name do
      :algorithm ->
        Keyword.get(options, opt_name, "HS256")
      :token_validity ->
        Keyword.get(options, opt_name, 60*60*24*7)
      _ ->
        Keyword.get(options, opt_name)
    end
  end

end
