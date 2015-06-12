defmodule Firebrick.Jwt do

  @token_validity Application.get_env(:firebrick, :jwt_token_validity, 60 * 60 * 24 * 365)
  @algorithm Application.get_env(:firebrick, :jwt_algorithm, "HS256")

  def encode(data) do
    encoded_header = encode_part(%{typ: "JWT", alg: @algorithm})
    current_time = :calender.universaltime
    token_expiry = calculate_token_expiry(current_time)

    registered_claims = %{
      iat: unix_timestamp(current_time),
      exp: unix_timestamp(token_expiry)
    }

    encoded_payload = data
    |> Map.merge(registered_claims)
    |> encode_part

    encoded_signature = signature(@algorithm, "#{encoded_header}.#{encoded_payload}")
    |> encode_part

    [
      encoded_header,
      encoded_payload,
      encoded_signature
    ] |> Enum.join(".")
  end


  defp calculate_token_expiry(datetime) do
    :calendar.datetime_to_gregorian_seconds(datetime)
    |> Kernel.+(@token_validity)
    |> :calendar.gregorian_seconds_to_datetime
  end


  defp encode_part(part) do
    Poison.encode!(part)
    |> Base.url_encode64
  end


  def decode(data) do
    [encoded_header, encoded_payload, encoded_signature] = String.split(data, ".")

    if signature_match?(encoded_header, encoded_payload, encoded_signature) do
      {:ok, Base.url_decode64(encoded_payload)}
    else
      {:error, "signature mismatch"}
    end
  end


  defp signature_match?(encoded_header, encoded_payload, encoded_signature) do
    {:ok, header} = Base.url_decode64(encoded_header)
    algorithm = Map.get(header, "alg")
    {:ok, decoded_signature} = Base.url_decode64(encoded_signature)

    signature(algorithm, "#{encoded_header}.#{encoded_payload}") == decoded_signature
  end


  #TODO
  # "RS256"
  # "RS384"
  # "RS512"
  # "ES256"
  # "ES384"
  # "ES512"
  defp signature(algorithm, data) do
    secret = Application.get_env(:firebrick, :jwt_secret)
    case algorithm do
      "HS256" ->
        :crypto.hmac(:sha256, secret, data)
      "HS384" ->
        :crypto.hmac(:sha384, secret, data)
      "HS512" ->
        :crypto.hmac(:sha512, secret, data)
    end
  end


  defp unix_timestamp(time) do
    #TODO
  end
end
