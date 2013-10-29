Gem::Specification.new do |s |
  s.name = 'integration-demos-lib'
  s.version = '1.0.0'
  s.date = Time.now
  s.summary = 'integration-demos-lib'
  s.description = 'Helper classes used by integration demos'
  s.authors = ['Nate Slater']
  s.email = 'nateslate@gmail.com'
  s.files = ['lib/integration-demos/aws/swf.rb', 'lib/integration-demos/aws/swf/domain_helper.rb',
             'lib/integration-demos/aws/swf/event_processing_activities.rb',
             'lib/integration-demos/aws/swf/event_processing_worker.rb']
end