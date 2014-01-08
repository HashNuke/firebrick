defmodule DomainsApiRouter do
  use Dynamo.Router
  import Firebrick.RouterUtils

  prepare do
    authorize_user!(conn, ["admin"])
  end


  get "/" do
    {domains, count, _} = Domain.query("type:domain")
    domains = lc domain inlist domains do
      domain.public_attributes
    end
    json_response([domains: domains], conn)
  end


  post "/" do
    {:ok, params} = conn.req_body
    |> JSEX.decode

    params = whitelist_params(params["domain"], ["name"])
    domain = Domain.assign_attributes(Domain[], params)

    case domain.save do
      {:ok, key} ->
        json_response [domain: domain.id(key)], conn
      {:error, domain} ->
        json_response [errors: domain.errors], conn
    end
  end


  delete "/:domain_id" do
    domain_id = conn.params["domain_id"]
    Domain.destroy domain_id
    json_response("", conn)
  end

end
