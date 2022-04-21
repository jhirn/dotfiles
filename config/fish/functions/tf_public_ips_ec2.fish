function tf_public_ips_ec2
  aws ec2 describe-instances \
    --filters Name=instance-state-name,Values=running Name=tag-value,Values="*?" \
    --query "Reservations[*].Instances[*].{PrivateIP:PrivateIpAddress, Server:Tags[?Key=='Name']|[0].Value}" \
    --output table
end
