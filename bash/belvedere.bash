
blade_logs() {
    sudo journalctl -f -u "Blade@$1" | sed -E 's/^([A-Z][a-z]{2} [0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}).*"message":"([^"]+)".*/\1: \2/' | sed 's/\\n/\n/g'
}

