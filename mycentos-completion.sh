function _foo() {
    local cur prev opts
    COMPREPLY=()

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    opts="help ls boot ssh status ping pause resume ss shutdown poweroff"

    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
    
}

complete -F _foo mycentos
