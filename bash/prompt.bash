# .bash_prompt


# jesse-hp prompt config
if [ $HOSTNAME = "jesse-hp" ]; then

    RESET="\[\033[0m\]"
    RED="\[\033[0;31m\]"
    GREEN="\[\033[01;32m\]"
    BLUE="\[\033[01;34m\]"
    YELLOW="\[\033[0;33m\]"
     
    PS_LINE=`printf -- '- %.0s' {1..200}`
    function parse_git_branch {
      PS_BRANCH=''
      PS_FILL=${PS_LINE:0:$COLUMNS}
      if [ -d .svn ]; then
        PS_BRANCH="(svn r$(svn info|awk '/Revision/{print $2}'))"
        return
      elif [ -f _FOSSIL_ -o -f .fslckout ]; then
        PS_BRANCH="(fossil $(fossil status|awk '/tags/{print $2}')) "
        return
      fi
      ref=$(git symbolic-ref HEAD 2> /dev/null) || return
      PS_BRANCH="(git ${ref#refs/heads/}) "
    }
    PROMPT_COMMAND=parse_git_branch
    PS_INFO="$GREEN\u@\h$RESET:$BLUE\w"
    PS_GIT="$YELLOW\$PS_BRANCH"
    PS_TIME="\[\033[\$((COLUMNS-10))G\] $RED[\t]"
    export PS1="\${PS_FILL}\[\033[0G\]${PS_INFO} ${PS_GIT}${PS_TIME}\n${RESET}\$ "
    
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source /usr/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
    #if [ -f ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]; then
    #    source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
    #fi
    
    # 256 color
    BASE16_SHELL=$HOME/.config/base16-shell/
    [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

elif [ $HOSTNAME = "raspberrypi" ]; then

    # Set terminal colours
    BLUE="\033[01;34m"
    GREEN="\033[01;32m"
    RESET="\033[0m"

    PS1="${GREEN}\u@\h ${BLUE}\w \n\A \$ ${RESET}"
else
    # Source for git information in prompt
    if [ "${HIDE_GIT_PS1}" != "1" -a -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
      source /usr/share/git-core/contrib/completion/git-prompt.sh
      GIT_PS1_SHOWDIRTYSTATE=1
      GIT_PS1_SHOWSTASHSTATE=1
      GIT_PS1_SHOWUNTRACKEDFILES=1
    #  GIT_PS1_SHOWUPSTREAM="verbose legacy git"
      GIT_PS1_DESCRIBE_STYLE=default
    #  GIT_PS1_SHOWCOLORHINTS=1
    else
      __git_ps1()
      {
        : # Git is not installed so stub out function
      }
    fi

    # Set terminal colours
    BASE03=$(tput setaf 234)
    BASE02=$(tput setaf 235)
    BASE01=$(tput setaf 240)
    BASE00=$(tput setaf 241)
    BASE0=$(tput setaf 244)
    BASE1=$(tput setaf 245)
    BASE2=$(tput setaf 254)
    BASE3=$(tput setaf 230)
    YELLOW=$(tput setaf 136)
    ORANGE=$(tput setaf 166)
    RED=$(tput setaf 160)
    MAGENTA=$(tput setaf 125)
    VIOLET=$(tput setaf 61)
    BLUE=$(tput setaf 33)
    CYAN=$(tput setaf 37)
    GREEN=$(tput setaf 64)
    BOLD=$(tput bold)
    RESET=$(tput sgr0)

    # If we're root, then let's see red
    if [ ${EUID} -eq 0 ] ; then
      USER_COLOUR="${RED}"
    else
      USER_COLOUR="${GREEN}"
    fi
    
    # Check if we're local or remote
    if [[ -n "${SSH_CLIENT}" || -n "${SSH_TTY}" ]] ; then
      # Prompt with hostname
      export PS1="\[${RESET}\][\[${BASE0}\]\A\[${RESET}\] \[${USER_COLOUR}\]\u@\h \[${CYAN}\]\w\[${YELLOW}\]\$(__git_ps1 \" (%s)\")\[${RESET}\]]\\$\[${RESET}\] "
    else
      # Just prompt
      export PS1="\[${RESET}\][\[${BASE0}\]\A\[${RESET}\] \[${USER_COLOUR}\]\u \[${CYAN}\]\w\[${YELLOW}\]\$(__git_ps1 \" (%s)\")\[${RESET}\]]\\$\[${RESET}\] "
    fi
    
    # Set terminal working directory length for use in PS1
    PROMPT_DIRTRIM=2

fi
