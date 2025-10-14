function switch-aws-profile
    set -gx AWS_PROFILE $argv[1]
    if ! aws sts get-caller-identity > /dev/null
        aws sso login
    end
    echo $AWS_PROFILE profile activated
end
