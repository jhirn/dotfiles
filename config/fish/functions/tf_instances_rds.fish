function tf_instances_rds
  set -l RDS_INSTANCES (aws rds describe-db-instances --output json )
  set -l NETWORK_INTERFACES (aws ec2 describe-network-interfaces --output json)

  for RDS_INSTANCE in (echo $RDS_INSTANCES | jq -r -c '.DBInstances[]')
    echo
    echo $RDS_INSTANCE | jq -r -c '(.DBInstanceIdentifier + "\n      Address: " +  .Endpoint.Address)'
    set -l PUBLIC_IP  (dig +short (echo $RDS_INSTANCE | jq -r -c '.Endpoint.Address') | tail -n 1)

    echo "    Public IP: " $PUBLIC_IP
    echo $NETWORK_INTERFACES | jq -r -c --arg public_ip $PUBLIC_IP '.NetworkInterfaces[] | select(.Association.PublicIp == $public_ip) | "   Private IP: " + .PrivateIpAddress'
  end
end
