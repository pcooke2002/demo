# control 'aws-lambda-1' do
#   impact 1.0
#   title 'Ensure Lambda function is configured correctly'
#   desc 'Check if the Lambda function has the correct settings'
#
#   aws_lambda_functions.function_names.each do |function_name|
#     describe aws_lambda_function(function_name: function_name) do
#       it { should exist }
#       its('runtime') { should eq 'python3.11' }
#       its('timeout') { should be <= 30 }
#     end
#   end
# end
#
# control 'aws-lambda-1' do
#   impact 1.0
#   title 'Ensure Lambda function is configured correctly'
#   desc 'Check if the Lambda function has the correct settings'
#
#   aws_lambda_functions.function_names.each do |function_name|
#     describe aws_lambda_function(function_name: function_name) do
#       it { should exist }
#       its('runtime') { should eq 'python3.8' }
#       its('timeout') { should be <= 30 }
#       its('environment_variables') { should_not be_empty }
#     end
#   end
# end