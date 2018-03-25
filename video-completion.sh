function _foo2() {
    local cur prev opts
    COMPREPLY=()

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    opts="help concat cut gif vgif record byzan_record"

    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
    
}

complete -F _foo2 video
