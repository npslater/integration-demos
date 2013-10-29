require 'rest-client'
require 'aws/decider'

class EventProcessingActivities
  extend AWS::Flow::Activities

  activity :fetch_data_activity do
    {
        :version => '1.03',
        :default_task_schedule_to_start_timeout => 30,
        :default_task_start_to_close_timeout => 30
    }
  end

  def fetch_data_activity(message)
    RestClient.get JSON.parse(message)['get_url'] do | response, request, result|
      json = response.body
      "#{json}"
    end
  end
end