require 'optparse'
require 'pp'
require 'aws/decider'
require_relative '../lib/integration-demos/aws/swf/event_processing_activities'
require_relative '../lib/integration-demos/aws/swf/event_processing_worker'
require_relative '../lib/integration-demos/aws/swf/domain_helper'

class RunWorker

  def initialize(args)
    @options = parse_args(args)
  end

  private

    def parse_args(args)
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: run_worker.rb [options]"
        opts.separator ""
        opts.separator "Specific options:"
        opts.on('-w', '--worker WORKER',
                'Specify whether to run the activities or workflow worker') do | worker |
          options[:worker] = worker
        end
        opts.on('-c', '--config CONFIG', 'Specify the path to the config file') do | config |
          options[:config] = config
        end
        opts.on('-d', '--domain DOMAIN', 'The SWF domain name') do | domain |
          options[:domain] = domain
        end
        opts.on('-t', '--tasklist TASKLIST', 'The default task list') do | tasklist |
          options[:tasklist] = tasklist
        end
        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
      end

      parser.parse!(args)
      if not options[:config].nil?
        config = load_config(options[:config])
        config.merge!(options)
        options = config
      end
      mandatory = [:worker, :domain, :tasklist]
      missing = mandatory.select{|param| options[param].nil?}
      if not missing.empty?
        puts "Missing options: #{missing.join(', ')}"
        puts parser
        exit
      end

      if ['activities', 'workflow'].select{|val| options[:worker].eql?(val)}.empty?
        puts 'Workflow must be one of [activities|worklfow]'
        puts parser
        exit
      end
      options
    end

    def load_config(config_file)
      config = YAML.load(File.read(config_file))
      Hash[config.map{|(k,v)| [k.to_sym,v]}]
    end

    def init_domain
      @swf = AWS::SimpleWorkflow.new

      begin
        @domain = @swf.domains[@options[:domain]]
        @domain.status
      rescue AWS::SimpleWorkflow::Errors::UnknownResourceFault => e
        @domain = @swf.domains.create(@options[:domain], '10')
      end
    end

  public

    def run
      init_domain()
      if @options[:worker].eql?('activities')
        fork do
          puts "Starting activity worker #{EventProcessingActivities}"
          activity_worker = AWS::Flow::ActivityWorker.new(@swf.client, @domain, @options[:tasklist], EventProcessingActivities)
          activity_worker.start
        end
      elsif @options[:worker].eql?('workflow')
        fork do
          puts "Starting workflow worker #{EventProcessingWorker}"
          worker = AWS::Flow::WorkflowWorker.new(@swf.client, @domain, @options[:tasklist], EventProcessingWorker)
          worker.start
        end
      end
    end
end

runner = RunWorker.new(ARGV)
runner.run()

