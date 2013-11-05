class Event

  attr_accessor :type
  attr_reader :payload

  def initialize(type, resource)
    @type = type
    @payload = {
        :resource => resource
    }
  end
end

class Resource
  attr_accessor :type, :unique_id, :get_url, :save_url

  def initialize(type, unique_id, get_url, save_url)
    @type = type
    @unique_id = unique_id
    @get_url = get_url
    @save_url = save_url
  end
end