Gem::Specification.new do |s |
  s.name = 'integration-demos-lib'
  s.version = '1.0.0'
  s.date = Time.now
  s.summary = 'integration-demos-lib'
  s.description = 'Helper classes used by integration demos'
  s.authors = ['Nate Slater']
  s.email = 'nateslate@gmail.com'
  s.files = %w(
        lib/integration-demos/aws/swf.rb
        lib/integration-demos/aws/swf/domain_helper.rb
        lib/integration-demos/aws/swf/event_processing_activities.rb
        lib/integration-demos/aws/swf/event_processing_worker.rb
        lib/integration-demos/docusign/docusign_client.rb
        lib/integration-demos/google/google_client.rb
        lib/integration-demos/servicebus/service_bus_client.rb)
  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'aws-flow'
  s.add_runtime_dependency 'multipart-post'
  s.add_runtime_dependency 'google-api-client'
end