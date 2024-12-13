# controls/security_group.rb
control 'aws-security-group-1' do
  impact 1.0
  title 'Ensure Security Group is configured correctly'
  desc 'Check if the Security Group has the correct settings'

  aws_security_groups.group_ids.each do |group_id|
    describe aws_security_group(group_id: group_id) do
      it { should exist }
      its('inbound_rules_count') { should be <= 10 }
      its('outbound_rules_count') { should be <= 10 }
      its('inbound_permissions') { should_not include(port: 22, protocol: 'tcp', cidr_blocks: ['0.0.0.0/0']) }
    end
  end
end