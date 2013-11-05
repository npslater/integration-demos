require 'event_processing_workflow'

class ServiceBusController < ApplicationController
  wrap_parameters false

  def receive_event
    wf = EventProcessingWorkflow.new(AppConfig.event_processing_workflow['domain_name'])
    wf.start_workflow(JSON.generate(params))
    render :nothing => true, :status => 200
  end

end