require 'aws/decider'
require 'integration-demos/aws/swf'

class EventProcessingWorkflow

  attr_reader :swf, :domain

  def initialize(domain_name)
    @swf = AWS::SimpleWorkflow.new
    @domain = DomainHelper.init_domain(swf, domain_name)
  end

  def start_workflow(event)
    workflow_client = AWS::Flow.workflow_client(@swf.client, @domain) {
      { :from_class => 'EventProcessingWorker'}
    }
    workflow_client.start_execution(event)
  end
end