require 'google/api_client'

class GoogleClient

  attr_reader :credentials, :redirect_url, :scopes

  def initialize(credentials, redirect_url, scopes)
    @credentials = credentials
    @redirect_url = redirect_url
    @scopes = scopes
  end

  private

    def client_id
      credentials[:client_id]
    end

    def client_secret
      credentials[:client_secret]
    end

  public

    def get_authorization_uri(email, state)
      client = Google::APIClient.new
      client.authorization.client_id = client_id
      client.authorization.redirect_uri = redirect_url
      client.authorization.scope = scopes

      uri  = client.authorization.authorization_uri
      uri.to_s
    end

end