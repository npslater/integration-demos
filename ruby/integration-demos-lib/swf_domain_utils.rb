require 'aws/decider'

config_file = File.join(File.dirname(__FILE__), 'config.yml')
@config = YAML.load(File.read(config_file))
#puts "config #{@config}"

@swf = AWS::SimpleWorkflow.new

begin
  @domain = @swf.domains[@config['domain_name']]
  @domain.status
rescue AWS::SimpleWorkflow::Errors::UnknownResourceFault => e
  @domain = @swf.domains.create(@config['domain_name'], '10')
end