require 'aws/decider'
require 'JSON'
require_relative 'swf_domain_utils'
require_relative 'event_processing_worker'

workflow_client = AWS::Flow.workflow_client(@swf.client, @domain) {
  { :from_class => 'EventProcessingWorker'}
}

puts "Starting an execution..."
workflow_client.start_execution(JSON.generate({:eventType => 'Test'}))