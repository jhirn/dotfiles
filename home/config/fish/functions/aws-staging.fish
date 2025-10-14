function aws-staging
    set -l instance_name $argv[1]
    set -l profile $argv[2]
    if test -z "$profile"
        set profile staging-admin
    end

    # If no instance name provided, show interactive selection
    if test -z "$instance_name"
        echo "Fetching available instances..."
        set -l instances_json (aws ec2 describe-instances \
            --profile $profile \
            --filter "Name=tag:Name,Values=rentbutter-*" "Name=instance-state-name,Values=running" \
            --output json 2>&1)

        # Check for token error
        if string match -q "*Token has expired*" "$instances_json"
            echo "AWS SSO token has expired. Refreshing..."
            aws sso login --profile $profile
            if test $status -eq 0
                echo "Token refreshed successfully. Retrying..."
                set instances_json (aws ec2 describe-instances \
                    --profile $profile \
                    --filter "Name=tag:Name,Values=rentbutter-*" "Name=instance-state-name,Values=running" \
                    --output json)
            else
                echo "Failed to refresh token. Please run: aws sso login --profile $profile"
                return 1
            end
        end

        # Parse JSON to get instance info
        set -l instance_ids (echo $instances_json | jq -r '.Reservations[].Instances[] | select(.State.Name == "running") | .InstanceId')
        set -l instance_names (echo $instances_json | jq -r '.Reservations[].Instances[] | select(.State.Name == "running") | .Tags[] | select(.Key == "Name") | .Value')

        if test (count $instance_ids) -eq 0
            echo "No running instances found with names starting with 'rentbutter-'"
            return 1
        end

        # Show selection menu
        echo "Available instances:"
        for i in (seq (count $instance_ids))
            set -l name (string replace "rentbutter-" "" $instance_names[$i])
            echo "  $i) $name"
        end

        echo "Select instance (1-"(count $instance_ids)"): "
        read -l selection

        # Validate selection
        if test -z "$selection" -o "$selection" -lt 1 -o "$selection" -gt (count $instance_ids)
            echo "Invalid selection"
            return 1
        end

        set instance_id $instance_ids[$selection]
        set instance_name (string replace "rentbutter-" "" $instance_names[$selection])
        echo "Selected: $instance_name ($instance_id)"
    end

    # If we have a specific instance name, look it up
    if test -n "$instance_name" -a -z "$instance_id"
        set instance_id (aws ec2 describe-instances \
            --profile $profile \
            --filter "Name=tag:Name,Values=rentbutter-$instance_name" \
            --query "Reservations[0].Instances[0].InstanceId" \
            --output text 2>&1)

        # Check if we got a token error
        if string match -q "*Token has expired*" "$instance_id"
            echo "AWS SSO token has expired. Refreshing..."
            aws sso login --profile $profile
            if test $status -eq 0
                echo "Token refreshed successfully. Retrying..."
                set instance_id (aws ec2 describe-instances \
                    --profile $profile \
                    --filter "Name=tag:Name,Values=rentbutter-$instance_name" \
                    --query "Reservations[0].Instances[0].InstanceId" \
                    --output text)
            else
                echo "Failed to refresh token. Please run: aws sso login --profile $profile"
                return 1
            end
        end

        # Check if we got a valid instance ID
        if test -z "$instance_id" -o "$instance_id" = "None"
            echo "No instance found with name: rentbutter-$instance_name"
            echo "Run 'aws-staging' without arguments to see available instances"
            return 1
        end
    end

    echo "Connecting to instance: $instance_id"
    aws ssm start-session --profile $profile --target "$instance_id"
end
