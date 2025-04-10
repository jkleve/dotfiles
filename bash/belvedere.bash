
blade_logs() {
    sudo journalctl -f -u "Blade@$1" | sed -E 's/^([A-Z][a-z]{2} [0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}).*"message":"([^"]+)".*/\1: \2/' | sed 's/\\n/\n/g'
}

which_blades() {
    local services
    services=$(systemctl list-units --type=service --all --no-legend --plain |  awk '/Blade@/ {print $1}' | sort)

    if [[ -z "$services" ]]; then
        echo "No Blade@ services found."
        return
    fi

    for service in $services; do
        # Remove any weird characters just in case
        clean_service=$(echo "$service" | tr -d '[:space:]')
        status=$(systemctl is-active "$clean_service")

        if [[ "$status" == "active" ]]; then
            echo -e "\e[32m$clean_service is $status\e[0m"
        else
            echo -e "\e[31m$clean_service is $status\e[0m"
        fi
    done
}
