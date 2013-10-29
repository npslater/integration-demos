require 'json'
require 'rest-client'

class ServiceBusClient

  attr_reader :event_url

  def initialize(options = {})
    @event_url = options[:event_url]
  end

  public

  def send_event(body)
    RestClient.post(@event_url, JSON.generate(body),
                    {:content_type => 'application/json', 'accept' => 'application/json'}) do |response, request, result|
      if response.code == 200
        return response.body
      else
        raise "HTTP Error: #{response.code}"
      end
    end

  end

end