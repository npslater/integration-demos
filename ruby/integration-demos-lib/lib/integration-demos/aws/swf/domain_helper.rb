require 'aws/decider'
class DomainHelper

  def self.init_domain(swf, domain_name)
    begin
      domain = swf.domains[domain_name]
      domain.status
    rescue AWS::SimpleWorkflow::Errors::UnknownResourceFault => e
      domain = swf.domains.create(domain_name, '10')
    end
    domain
  end
end