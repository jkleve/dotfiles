# .bash_functions

#function cd {
#    builtin cd "$@" && ls -F
#}

function mkd {
    echo "making $@"
    mkdir "$@" && cd "$1"
}

function rmd {
    echo "Moving $@ to ~/.local/share/Trash/files/"
    mv "$@" ${HOME}/.local/share/Trash/files/
}

delete() {
    for f in "$@"; do
        file=${f%/}
        mv -f "$file" "/tmp/${file}_${RANDOM}"
    done
}

#function macs {
#    dir=$(pwd)
#    declare -a params
#    for file in "$@"; do
#	    params=" $params $dir/$file"
#    done
#
#    emacs -nw $params
#}

# Extra many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar -jxvf "$1"                        ;;
      *.tar.gz)   tar -zxvf "$1"                        ;;
      *.bz2)      bunzip2 "$1"                          ;;
      *.dmg)      hdiutil mount "$1"                    ;;
      *.gz)       gunzip "$1"                           ;;
      *.tar)      tar -xvf "$1"                         ;;
      *.tbz2)     tar -jxvf "$1"                        ;;
      *.tgz)      tar -zxvf "$1"                        ;;
      *.zip)      unzip "$1"                            ;;
      *.ZIP)      unzip "$1"                            ;;
      *.pax)      cat "$1" | pax -r                     ;;
      *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
      *.Z)        uncompress "$1"                       ;;
      *) echo "'$1' cannot be extracted/mounted via extract()" ;;
    esac
  else
     echo "'$1' is not a valid file to extract"
  fi
}

get_ip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

get_timezone() {
    ip=$(get_ip)
    curl -s freegeoip.net/xml/${ip} | grep TimeZone | awk -F"[<>]" '{print $3}'
}

update_time() {
    local user_confirmation=
    timezone=$(get_timezone)   

    if [[ $timezone = "America/Chicago" ]]; then
        timezone_file=/usr/share/zoneinfo/America/Chicago
    elif [[ $timezone = "America/Denver" ]]; then
        timezone_file=/usr/share/zoneinfo/America/Denver
    else
        echo "Didn't find timezone ${timezone}"
        return 1
    fi

    # User confirmation
    echo "Set localtime to ${timezone_file} [yn]"
    read -n 1 user_confirmation
    case "$user_confirmation" in
        y|Y) sudo ln -vsf ${timezone_file} /etc/localtime ;;
        *) echo "Doing nothing" ;;
    esac
}

wifi-conn() {
    if [ -z "$1" ]; then
        echo "wifi-conn <ssid> <password>"
    fi
    if [ -z "$2" ]; then
        echo "wifi-conn <ssid> <password>"
    fi
    nmcli dev wifi connect "$1" --password "$2"
}
