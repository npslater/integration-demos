require 'spec_helper'

describe DocuSignClient do

  let!(:config) { YAML.load(ERB.new(File.read(File.join(File.dirname(__FILE__), 'config.yml'))).result) }
  let!(:credentials) { {:username => config['docusign']['username'], :password => config['docusign']['password'], :key => config['docusign']['key'] } }
	
	let!(:client) { DocuSignClient.new(credentials) }
	let!(:login_url) { config['docusign']['login_url'] }

	let(:base_url) {
		DocuSignClient.new(credentials).login(login_url)['loginAccounts'][0]['baseUrl']
	}

	let(:signers) {
		[
			{
				:email => config['docusign']['recipient_email'],
				:name => config['docusign']['recipient_name'],
				:role => config['docusign']['template_role_name'],
        :tabs => [
            {
                :xPosition => 100,
                :yPosition => 100,
                :pageNumber => 1
            }
        ]
			}
		]
	}

	let(:template_id) { config['docusign']['template_id'] }

	let(:email_opts) {
		{
			:emailSubject =>'Docusign API calls - Programmatic Sending', 
			:emailBlurb => 'This was sent using the REST API in a ruby program'
		}
	}

	let(:envelope_id) {
		client.create_envelope(base_url, template_id, email_opts, signers)['envelopeId']
	}

	let(:return_url) { 'http://localhost:3000/docusign/finish' }

  let(:docs) {
    [
        {
            :path => File.expand_path('./Test.txt',  File.dirname(__FILE__)),
            :content_type => 'text/plain'
        }
    ]
  }

	it 'should have a constructor that takes a hash of credentials and returns an instance' do
		puts "config: #{config['docusign']}"
		client.should be_an_instance_of(DocuSignClient)
	end

	it 'should return a hash on successful login' do
		client.login(config['docusign']['login_url']).should be_an_instance_of(Hash)
	end

	it 'should have a base_url property in the hash returned from successful login' do
		base_url = client.login(login_url)['loginAccounts'][0]['baseUrl']
		base_url.should_not be_nil
	end

	it 'should return a hash on successful envelope creation' do
		client.create_envelope(base_url, template_id, email_opts, signers).should be_an_instance_of(Hash)
	end

	it 'should have a envelope_id property in the hash returned from successful envelope creation' do
		envelope_id = client.create_envelope(base_url, template_id, email_opts, signers)['envelopeId']
		envelope_id.should_not be_nil
	end

	it 'should return a URL to the recipient view for the envelope Id returned from envelope creation' do
		client.recipient_view_url(base_url, envelope_id, return_url, signers[0]).should_not be_nil
	end

	it 'should send a document for signature request' do
		client.request_document_signature(base_url, 'email subject', signers, docs)
	end
end