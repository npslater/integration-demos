require 'spec_helper'

describe DomainHelper do

  let(:config) { YAML.load(File.read(File.join(File.dirname(__FILE__), 'config.yml'))) }
  let(:swf) { AWS::SimpleWorkflow.new }

  it 'should return an instance of AWS::SimpleWorkflow::Domain' do
    domain = DomainHelper.init_domain(swf, config['domain'])
    domain.should be_an_instance_of(AWS::SimpleWorkflow::Domain)
  end
end

describe EventProcessingActivities do

  let(:config) { YAML.load(File.read(File.join(File.dirname(__FILE__), 'config.yml'))) }
  let(:swf) { AWS::SimpleWorkflow.new }
  let(:domain) { DomainHelper.init_domain(swf, config['domain']) }

  it 'should return an instance of EventProcessingActivities' do

    worker = EventProcessingActivities.new
    worker.should be_an_instance_of(EventProcessingActivities)
  end

  it 'should be runnable as an AWS::Flow::ActivityWorker' do

    activity_worker = AWS::Flow::ActivityWorker.new(swf.client, domain, config['tasklist'], EventProcessingActivities)
    activity_worker.should be_an_instance_of(AWS::Flow::ActivityWorker)
  end
end

describe EventProcessingWorker do

  let(:config) { YAML.load(File.read(File.join(File.dirname(__FILE__), 'config.yml'))) }
  let(:swf) { AWS::SimpleWorkflow.new }
  let(:domain) { DomainHelper.init_domain(swf, config['domain']) }

  it 'should return an instance of EventProcessingWorker' do
    worker = EventProcessingWorker.new
    worker.should be_an_instance_of(EventProcessingWorker)
  end

  it 'should be runnable as an AWS::Flow::WorkflowWorker' do
    workflow_worker = AWS::Flow::WorkflowWorker.new(swf.client, domain, config['tasklist'], EventProcessingWorker)
    workflow_worker.should be_an_instance_of(AWS::Flow::WorkflowWorker)
  end
end