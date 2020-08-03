# -*- ove-mode: 1; cursor-type: box; -*-
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
#HISTCONTROL=ignoredups：忽略连续重复的命令。
#HISTCONTROL=ignorespace：忽略以空白字符开头的命令。
#HISTCONTROL=ignoreboth：同时忽略以上两种。
#HISTCONTROL=erasedups：忽略所有历史命令中的重复命令。
#HISTCONTROL=ignoreboth
HISTCONTROL=erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx

alias ll='ls -l'
alias emacs='emacs -nw'
###alias vi='emacs -nw'
###export EDITOR='EMACS_START="emacs_start" emacs -nw -Q -f menu-bar-mode'
export EDITOR='emacsclient -t'


#swap the Ctrl and CapLocks
#/usr/bin/setxkbmap -option "ctrl:swapcaps"
#interupt the TouchpadOff
#synclient TouchpadOff=1

export LANGUAGE="en_US.utf8"

alias grun='java -classpath .:/usr/share/java/stringtemplate4.jar:/usr/share/java/antlr4.jar:/usr/share/java/antlr4-runtime.jar:/usr/share/java/antlr3-runtime.jar:/usr/share/java/treelayout.jar:$CLASSPATH org.antlr.v4.gui.TestRig'



if [ ! -z "$TMUX" ]; then
    #    export TERM=xterm-256color
    #    tmux attach-session -t "$USER" || tmux new-session -s "$USER"
    export PROMPT_COMMAND='tmux set -g status-right "#(whoami)@#h:#{pane_current_path}"'
fi

if [ "$TERM" != "screen-256color" ] && [ "$EMACS_START" != "emacs_start" ]
then
    #tmux attach-session -t "$USER" || tmux new-session -s "$USER"
    # 启用一个名为 network 的 session 来运行 networkautostart 这个脚本
    #tmux has-session -t network &> /dev/null
    #if [ $? != 0 ]
    #then
    #     tmux new-session -s network -d
    #     tmux send-keys -t network 'networkautostart' C-m
    #fi
    tmux has-session -t emacsserver &> /dev/null
    if [ $? != 0 ]; then
        tmux new-session -s emacsserver -d
    fi
    emacsclient -e '(server-running-p)' &> /dev/null
    if [ $? != 0 ]; then
        tmux send-keys -t emacsserver \
             '/usr/local/bin/emacs -f server-start -f ove-mode -nw' C-m
    fi
    mylocation=$(tty|cut -d'/' -f3)
    if [ "$mylocation" == "pts" ]; then
        tmux
        exit
    fi
fi




#[ -z "$TMUX" ] && export TERM=xterm-256color
#export MANPATH=/usr/man:/usr/share/man:~/backups/src/manpages_zh/man/
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias myip="/sbin/ifconfig wlp9s0|awk '/inet/{print \$2}'"
alias e="emacsclient -t"

#if [ $PWD == $HOME ]; then
#    export PS1="\u@\h:\w\$ "
#else
#    export pS1="\u@\h:$PWD\$ "
#fi



if [ "$EMACS_START" != "emacs_start" ]; then
    # 颜色设定格式 \[\e[F;Bm\]...\[\e[0m\]
    # export PS1="\W\$ "
    export PS1="\[\e[37;46m\]\W\$\[\e[0m\]\[\e[37;45m\]  \[\e[0m\] "
    #　颜色对照表：
    #　　　　F    B
    #　　　　30  40 黑色
    #　　　　31  41 红色
    #　　　　32  42 绿色
    #　　　　33  43 黄色
    #　　　　34  44 蓝色
    #　　　　35  45 紫红色
    #　　　　36  46 青蓝色
    #　　　　37  47 白色

    # set completion-ignore-case on
    # set show-all-if-ambiguous on
    # bind TAB:menu-complete

    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi
export FZF_DEFAULT_COMMAND='fd --type file'

[ -f ~/bin/mycentos-completion.sh ] && source ~/bin/mycentos-completion.sh
[ -f ~/bin/video-completion.sh ] && source ~/bin/video-completion.sh
