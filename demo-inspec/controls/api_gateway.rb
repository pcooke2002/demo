# controls/api_gateway.rb
require 'pry'
control 'api-gateway-exists' do
  impact 1.0
  title 'Ensure the API Gateway exists'
  desc 'Validates that the specified API Gateway is present in the AWS account.'
  describe aws_api_gateway_resource(rest_api_id: input('rest_api_gw_id'), resource_id: input('rest_gateway_resource_id')) do
    it { should exist }
    its('id') { should cmp input('rest_gateway_resource_id') }
    its('path') { should_not be_nil }
    its('parent_id') { should_not be_nil }
    its('path_part') { should_not be_nil }
    its('minimum_compression_size') { should be <= 0 }
    its('resource_methods') { should_not be_nil }
    puts "*********"
    puts it
    binding.pry
  end
end

control 'api-gateway-deployment-exists' do
  impact 1.0
  title 'Ensure the API Gateway deployment exists'
  desc 'Validates that the specified API Gateway deployment is present in the AWS account.'
  describe aws_api_gateway_deployment(rest_api_id: input('rest_api_gw_id'), deployment_id: input('deployment_id')) do
    it { should exist }
    its('description') { should_not be_nil }
    its('created_date') { should cmp Date.today }
  end
end