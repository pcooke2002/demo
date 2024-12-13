# controls/s3.rb
require 'pry'
control 'aws-s3-buckets' do
  impact 1.0
  title 'Ensure S3 buckets are configured correctly'
  desc 'Check if the S3 buckets have the correct settings'


  input('aws_s3_bucket_names').each do |bucket_name|
    describe aws_s3_bucket(bucket_name: bucket_name) do
        it { should exist }
        its('bucket_acl') { should_not include('public-read') }
    end
  end
end