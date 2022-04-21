function tf_public_ips_rds
  set -l RDS_INSTANCES (aws rds describe-db-instances --output json )

  for RDS_INSTANCE in (echo $RDS_INSTANCES | jq -r -c '.DBInstances[]')
    echo $RDS_INSTANCE | jq -r -c '("Instance: " + .DBInstanceIdentifier + "\n   Address: " +  .Endpoint.Address)'
    set -l PUBLIC_IP  (dig +short (echo $RDS_INSTANCE | jq -r -c '.Endpoint.Address') | tail -n 1)
    echo "   Public IP:" $PUBLIC_IP
  end
end
