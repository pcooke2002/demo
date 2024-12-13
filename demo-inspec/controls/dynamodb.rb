control 'aws-dynamodb-1' do
  impact 1.0
  title 'Ensure DynamoDB table is configured correctly'
  desc 'Check if the DynamoDB table has the correct settings'

  aws_dynamodb_tables.table_names.each do |table_name|
    describe aws_dynamodb_table(table_name: table_name) do
      it { should exist }
      its('billing_mode') { should eq 'PAY_PER_REQUEST' }
      its('point_in_time_recovery') { should be_enabled }
    end
  end
end

control 'aws-dynamodb-1' do
  impact 1.0
  title 'Ensure DynamoDB table is configured correctly'
  desc 'Check if the DynamoDB table has the correct settings'

  aws_dynamodb_tables.table_names.each do |table_name|
    describe aws_dynamodb_table(table_name: table_name) do
      it { should exist }
      its('billing_mode') { should eq 'PAY_PER_REQUEST' }
      its('point_in_time_recovery') { should be_enabled }
      its('server_side_encryption') { should be_enabled }
    end
  end
end