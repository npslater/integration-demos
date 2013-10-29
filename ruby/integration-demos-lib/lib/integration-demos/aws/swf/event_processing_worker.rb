require 'aws/decider'

class EventProcessingWorker
  extend AWS::Flow::Workflows

  workflow :event_processing_workflow do
    {
        :version => '1.02',
        :execution_start_to_close_timeout => 3600,
        :default_task_list => 'integration_demos_task_list'
    }
  end

  activity_client(:activity) {
    {
      :from_class => 'EventProcessingActivities'
    }
  }

  def event_processing_workflow(message)
    val = activity.fetch_data_activity(message)
  end
end