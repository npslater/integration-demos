require 'spec_helper'

class ServiceBusClientSpec

  describe ServiceBusClient do

    let(:options) {
      { :event_url => AppConfig.servicebus['event_url'] }
    }

    let(:event) { Event.new('IntegrationDemos::Events::PurchaseOrderSaved',
                            Resource.new('IntegrationDemos::Resources::PurchaseOrder',
                                         '1',
                                         'http://localhost:3000/purchase_orders/1.json',
                                         'http://localhost:3000/purchase_orders'))
    }

    it "should take a hash of options and return an instance of ServiceBusClient" do
      client = ServiceBusClient.new(options)
      client.should be_an_instance_of(ServiceBusClient)
    end

    it 'should set the event_url property during initialization' do

      client = ServiceBusClient.new(options)
      client.event_url.should equal AppConfig.servicebus['event_url']
      client.event_url.should_not be_nil
    end

    it "should return HTTP 200 when a well formed JSON event message is sent" do
      client = ServiceBusClient.new(options)
      client.send_event(event)
    end
  end

end