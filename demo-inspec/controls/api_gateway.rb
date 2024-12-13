control 'aws-api-gateway-1' do
  impact 1.0
  title 'Ensure API Gateway is configured correctly'
  desc 'Check if the API Gateway has the correct settings'

  aws_api_gateways.rest_api_ids.each do |rest_api_id|
    describe aws_api_gateway(rest_api_id: rest_api_id) do
      it { should exist }
      its('minimum_compression_size') { should be <= 0 }
      its('api_key_source') { should eq 'HEADER' }
    end
  end
end

control 'aws-api-gateway-1' do
  impact 1.0
  title 'Ensure API Gateway is configured correctly'
  desc 'Check if the API Gateway has the correct settings'

  aws_api_gateways.rest_api_ids.each do |rest_api_id|
    describe aws_api_gateway(rest_api_id: rest_api_id) do
      it { should exist }
      its('minimum_compression_size') { should be <= 0 }
      its('api_key_source') { should eq 'HEADER' }
      its('logging_level') { should eq 'INFO' }
    end
  end
end