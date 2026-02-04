# Fish completion for adr (Architecture Decision Records)
# Uses the bash _adr_autocomplete function provided by adr-tools

function __fish_adr_complete
    # Get all commandline tokens
    set -l tokens (commandline -opc)

    # Join tokens with spaces for bash function
    set -l cmdline (string join ' ' $tokens)

    # Call the bash autocomplete function
    # _adr_autocomplete returns space-separated values
    set -l result (bash -c "_adr_autocomplete $cmdline" 2>/dev/null)

    # If result is empty, return (no completions)
    if test -z "$result"
        return
    end

    # Split space-separated results and output each on a new line
    string split ' ' -- $result
end

# Register completion for adr command
complete -c adr -f -a '(__fish_adr_complete)'
