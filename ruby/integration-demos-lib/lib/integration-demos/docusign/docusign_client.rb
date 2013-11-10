require 'json'
require 'rest-client'
require 'net/http/post/multipart'
require 'openssl'

class DocuSignClient

	attr_reader :credentials 
    private :credentials

    private

    	def initialize(credentials = {})
    		@credentials = credentials
    	end

        def auth_header
            "<DocuSignCredentials><Username>#{credentials[:username]}</Username><Password>#{credentials[:password]}</Password><IntegratorKey>#{credentials[:key]}</IntegratorKey></DocuSignCredentials>" 
        end

        def headers
            {'X-Docusign-Authentication' => auth_header, 'content-type' => 'application/json', 'accept' => 'application/json'}
        end

        def headers_multipart
          {'X-Docusign-Authentication' => auth_header, 'content-type' => 'multipart/form-data'}
        end

        def initialize_net_http_ssl(uri)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true

          # Explicitly verifies that the certificate matches the domain. Requires
          # that we use www when calling the production DocuSign API
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          http
        end

        def init_multipart_post_request(uri, payload)
          request = Net::HTTP::Post::Multipart.new(uri.request_uri, payload, headers)
          request.body = request.body_stream.read
          puts request.body
          request
        end

        def create_envelope_request_body(template_id, email_opts, signers)
            
            roles = []
            signers.each do |signer|
                roles.push({:email => signer[:email], :name => signer[:name], :roleName => signer[:role], :clientUserId => signer[:email]})
            end
            JSON.generate({
                :emailSubject => email_opts[:emailSubject],
                :emailBlurb => email_opts[:emailBlurb],
                :templateId => template_id,
                :templateRoles => roles,
                :status => 'sent'
            })
        end

        def recipient_view_request_body(return_url, signer)
            JSON.generate({
                :returnUrl => return_url,
                :authenticationMethod => 'email',
                :email => signer[:email],
                :userName => signer[:name],
                :clientUserId => signer[:email]
                })
        end

        def document_signature_payload(email_subject, signers, documents)
          { :body => UploadIO.new(StringIO.new(JSON.generate(create_document_signature_body(email_subject, signers, documents))), 'application/json', 'body.json', 'Content-Disposition' => 'form-data')}.merge!(create_upload_ios(documents))
          #{:body => JSON.generate(createDocumentSignatureBody(emailSubject, signers, documents))}.merge!(create_upload_ios(documents))
        end

        def create_document_signature_body(email_subject, signers, documents)
            body = {
                :recipients => {
                    :signers => []
                },
                :documents => [],
                :status => 'sent',
                :emailSubject => email_subject
            }
            signers.each_with_index do | signer, index|
                s = {
                        :email => signer[:email],
                        :name => signer[:name],
                        :recipientId => "#{index+1}",
                        :tabs => {
                            :signHereTabs => []
                    }
                }
                signer[:tabs].each do | tab |
                    s[:tabs][:signHereTabs].push({
                            :xPosition => tab[:xPosition],
                            :yPosition => tab[:yPosition],
                            :documentId => tab[:documentIndex] ? tab[:documentIndex] + 1 : 1,
                            :pageNumber => tab[:pageNumber]
                        })
                end
                body[:recipients][:signers].push(s)
            end
            documents.each_with_index do | doc, index|
                body[:documents].push({
                        :name => File.basename(doc[:path]),
                        :documentId => "#{index+1}"
                    })
            end
            body
        end

        def create_upload_ios(documents)
          ios = {}
          documents.each_with_index do | doc, index |
            ios.merge!({ "file#{index+1}" => UploadIO.new(doc[:path], doc[:content_type], File.basename(doc[:path]), 'Content-Disposition' => "file; documentId=#{index+1}")})
          end
          ios
        end

    public

        def login(url)
            RestClient.get(url, headers) do |response|
                if response.code == 200
                    return JSON.parse(response.body)
                else
                    raise "HTTP Error: #{response.code}"
                end
            end 
        end

        def create_envelope(base_url, template_id, email_opts = {}, signers=[])
            RestClient.post("#{base_url}/envelopes", create_envelope_request_body(template_id, email_opts, signers), headers) do |response|
                if response.code == 201
                    return JSON.parse(response.body)
                else
                    raise "HTTP Error: #{response.code}"
                end
            end
        end

        def recipient_view_url(base_url, envelope_id, return_url, signer = {})
            RestClient.post("#{base_url}/envelopes/#{envelope_id}/views/recipient", recipient_view_request_body(return_url, signer), headers) do |response|
                if response.code == 201
                    return JSON.parse(response.body)
                else
                    puts "ERROR: #{response.body}"
                    raise "HTTP Error: #{response.code}"
                end
            end 
        end

        def request_document_signature(base_url, email_subject, signers = [], documents = [])
            uri = URI.parse("#{base_url}/envelopes")
            http = initialize_net_http_ssl(uri)
            payload = document_signature_payload(email_subject, signers, documents)
            puts payload
            request = init_multipart_post_request(uri, payload)
            response = http.request(request)
            puts response.body
        end
end