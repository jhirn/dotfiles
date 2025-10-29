complete -c aws-profile -f -a '(awk " /\\[profile/ { sub(/]/, \"\", \$2); print \$2 }" ~/.aws/config)'
