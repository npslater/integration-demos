require 'spec_helper'
require 'JSON'

class EventProcessingWorkflowSpec

  describe EventProcessingWorkflow do

    let(:wf) { EventProcessingWorkflow.new(AppConfig.event_processing_workflow['domain_name'])}

    let(:event) {
      {
          :type => 'IntegrationDemos::PurchaseOrderStatusChange',
          :payload => {
              :status => 'New'
          },
          :resource => 'IntegrationDemos::PurchaseOrder',
          :id => '1',
          :get_url => 'http://localhost:3000/purchase_orders/1.json'
      }
    }

    it "should return an instance of an EventProcessingWorkflow" do
      wf.should be_an_instance_of(EventProcessingWorkflow)
    end

    it "should start the workflow without errors" do
      wf.start_workflow(event)
    end
  end
end