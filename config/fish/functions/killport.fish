function killport -d "kill whatever is running on this port"
    if test $argv -ge 1024
        and test $argv -le 65535
        lsof -i TCP:$argv | awk 'NR > 1 {print $2}' | xargs kill -9
    else
        echo "Must choose a port between 1024 and 65535"
    end
end
