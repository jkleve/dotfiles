
# OS
OS=$(uname -s)

PATH=$PATH:$HOME/.local/bin:$HOME/bin:./
PYTHONPATH=$PYTHONPATH:~/Code/python_modules

# Android
ANDROID_HOME=~/code/Android
JAVA_HOME=/usr/java/jdk1.8.0_131
export ANDROID_HOME
export JAVA_HOME
PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

export PATH
export PYTHONPATH
export TERM=xterm-256color

# Fuck cli program
alias fuck='eval $(thefuck $(fc -ln -1)); history -r'
alias FUCK='fuck'

MY_BASH_BLUE="\033[0;34m" #Blue
MY_BASH_NOCOLOR="\033[0m"

# HISTTIMEFORMAT uses strftime: http://man7.org/linux/man-pages/man3/strftime.3.html
HISTTIMEFORMAT=`echo -e ${MY_BASH_BLUE}[%m/%d %H:%M] $MY_BASH_NOCOLOR `
HISTSIZE=20000
HISTFILESIZE=20000

LD_LIBRARY_PATH=/usr/local/lib
