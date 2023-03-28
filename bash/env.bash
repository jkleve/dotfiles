
# OS
export OS=$(uname -s)

export PATH=$PATH:$HOME/.local/bin:$HOME/bin:./
export PYTHONPATH=$PYTHONPATH:~/Code/python_modules

export TERM=xterm-256color

export LD_LIBRARY_PATH=/usr/local/lib

export TZ=America/Denver
export DOCKER_BUILDKIT=1

MY_BASH_BLUE="\033[0;34m" #Blue
MY_BASH_NOCOLOR="\033[0m"

# HISTTIMEFORMAT uses strftime: http://man7.org/linux/man-pages/man3/strftime.3.html
export HISTTIMEFORMAT=`echo -e ${MY_BASH_BLUE}[%m/%d %H:%M] $MY_BASH_NOCOLOR `
export HISTSIZE=20000
export HISTFILESIZE=20000

unset MY_BASH_BLUE MY_BASH_NOCOLOR
