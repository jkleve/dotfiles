# .bash_alias

alias vi="vim"

# Re-source
alias bashrc='vi ~/.bashrc && source ~/.bashrc'
alias rload='source ~/.bashrc'

# Edit sources
alias rc="vi ${DOTFILES}/bash/alias.bash"
alias vimrc='vi ~/.vimrc'
alias i3rc='vi ~/.config/i3/config'
alias ealias="vi ${DOTFILES}/bash/alias.bash"

alias c=clear

# dnf
alias version?='dnf info'
#alias update='sudo dnf upgrade' # moved to a script

alias bedtime='sudo systemctl suspend'

# filesystem
alias df='df -hT'
alias backup='rsync -avibue "ssh" --delete --delete-excluded --exclude-from=/home/jesse/.dotfiles/rsync/rsync_excludes.conf ~/ pi@10.0.0.162:/media/external_drive/jesse-hp_backup $*'

# ssh
alias pi='ssh raspberrypi'

# network
#alias internet-restart='sudo /etc/init.d/network-manager restart'
alias internet-restart='systemctl restart NetworkManager'
alias ir='internet-restart'
alias open-ports='sudo nmap -sT -O localhost'
alias op='open-ports'
alias ping-google='ping -c 3 www.google.com'
alias pg='ping-google'
alias socket='ss -ltp | grep ' # print open ports with socket number
alias host-scan='nmap -sP 192.168.1.1/24'
alias hs='host-scan'
alias ir='internet-restart'
#alias wifi='nohup wicd-gtk &>/dev/null & disown %%'
alias wifi-scan='nmcli dev wifi list'
alias wifi-search='wifi-scan'
alias ws='wifi-scan'
alias wifi='wifi-scan'
alias p='ping-google'
alias public-ip='dig +short myip.opendns.com @resolver1.opendns.com'

# Programs
alias pandora='pithos'
# ncmpcpp
alias player='ncmpcpp'
alias play='player'
alias playerrc='vi ~/.ncmpcpp/config'
alias playrc='playerrc'
# google music
alias gmusic='playmusiccl'
alias alsa='alsamixer'
alias audio='alsamixer'
alias a='audio'
alias sound-cards='arecord -l'
# open files
alias pdf='evince'
# games
alias tetris='bastet'
alias dungeon='nethack'
# Minecraft
alias minecraft="java -jar /opt/Minecraft.jar 2>&1 > /dev/null"
# tree
alias tree='tree -FC'
# less is NOT more, but it is...
alias less='less -Ri' # R = raw (ANSI colors). i = case in-sensitive on searches
alias h='history | tail -20'

# weather
#alias forecast='weather-app 50014 -f'
alias weather='curl wttr.in/denver'
alias fore='forecast'
alias cast='forecast'
alias temp='weather-app 80211 -t'

alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "percentage\|time to empty"'
alias directory-size='du -sch'
alias dir-size='directory-size'
alias ds='directory-size'
#alias gpu='lspci -nnk | grep -i vga -A3'
#aliad gpu='lspci-vnnn | grep -i vga -A3'
alias gpu='glxinfo | egrep "OpenGL vendor|OpenGL renderer"'
alias o='thunar &'
alias off='sudo shutdown now'
alias output='volume'
alias playback='volume'
alias plog='vi ~/.personal_log'
alias pl='plog'
alias log='plog'
alias restart='sudo shutdown -r now'
alias s='sudo !!'
alias speed-test='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip'
alias st='speed-test'
alias usb='ls /dev | grep "USB\|ACM"'
alias volume='pavucontrol'
alias bluetooth='bluetoothctl'

# ls
alias ls='LC_COLLATE=C ls -NF --color=auto'
alias l='ls -lFh --color=auto'
alias ll='l'
alias lsl='ls -lFhN'
alias lsla='ls -lFAhN'
alias lla='ls -lFAhN'
alias llA='ls -lFahN'
alias lA='ls -FAN'
alias lsf="ls -lhN | grep -E '([0-9]+(M|G)+)*'"
alias lsfa="ls-lhaN | grep -E '([0-9]+(M|G)+)*'"
alias lsd='ls -lthr'
alias ls-size='ls -lShr'
alias lss='ls-size'

# directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# dirs, pushd, popd
alias dirs='dirs -v'

# programming aliases
alias remake='make clean all'
#alias load='sudo make load'
#alias load='sudo avrdude -p atmega2560 -c dragon_isp -P usb -e -v -U flash:w:src/quad-atmega2560.hex'
#alias jtagload='sudo avrdude -p atmega2560 -c dragon_jtag -P usb -e -v -U flash:w:src/quad-atmega2560.hex'
#alias jload='jtagload'
#alias listen='sudo python3 listen.py'
#alias send='sudo python send_power.py'
#alias ground='sudo python3 ground_station.py'
alias clean='make clean'
alias sloc='cloc'

# dhcp
alias dhcp-clients='watch -d -n 2 "cat /var/lib/dhcpd/dhcpd.leases"'

# radio
alias 70s='mplayer http://listen.radionomy.com:80/1HITS70s'
alias 80s='mplayer http://23.92.61.227:9000/stream.mp3'
alias 90s='mplayer http://46.105.108.89:8000'
alias 90shit='mplayer http://listen.radionomy.com:80/1HITS90s'
alias ibiza='mplayer http://198.105.220.12:9623/Live'
alias top40='mplayer http://listen.shoutcast.com:80/RadioHunter-TheHitzChannel'
alias blues='mplayer http://185.33.21.112:11041'
alias alternative='mplayer http://69.46.78.178:80'

# tv
alias airport='livestreamer http://www.ustream.tv/channel/%E5%A4%A7%E9%98%AA%E7%A9%BA%E6%B8%AFhd%E3%83%A9%E3%82%A4%E3%83%96%E3%82%AB%E3%83%A1%E3%83%A9 best'
alias iss='livestreamer http://www.ustream.tv/channel/iss-hdev-payload best'

# gpu
alias gpu-in-use="lspci -vnnn | perl -lne 'print if /^\d+\:.+(\[\S+\:\S+\])/' | grep VGA"
alias gpu-drivers="lspci -nnk | grep -i vga -A3 | grep 'in use'"

# tmux
alias tl="tmux ls"
alias tk="tmux kill-session -t"
alias tn="tmux new-session -s || tmux new-session -s main"
alias ta="tmux attach || tmux attach -t || tn"
