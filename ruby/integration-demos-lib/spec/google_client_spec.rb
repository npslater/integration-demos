require 'spec_helper'

describe GoogleClient do

  let!(:config) { YAML.load(ERB.new(File.read(File.join(File.dirname(__FILE__), 'config.yml'))).result) }
  let!(:credentials) {
    {
        :client_id => config['google']['client_id'],
        :client_secret => config['google']['client_secret']
    }
  }
  let(:client) { GoogleClient.new(credentials, config['google']['redirect_url'], config['google']['scopes']) }
  let(:email) { "nateslate@gmail.com" }
  let(:state) { "authorizationCode"}

  it 'should have a constructor that returns an instance of Googleclient' do
    client = GoogleClient.new(credentials, config['google']['redirect_url'], config['google']['scopes'])
    client.should be_an_instance_of(GoogleClient)
  end

  it 'should return a URL when get_authorization_uri is called' do
    url = client.get_authorization_uri(email, state)
    url.should be_an_instance_of(String)
  end
end