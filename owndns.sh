#!/bin/bash

# Supported registrars
# 0 => iwantmyname
# 1 => CloudFlare
REGISTRAR="1";

# Domain to be updated
DOMAIN="arne.me"

# Authentification for registrar
EMAIL="me@domain.com"
PASSWORD=""
TOKEN="623874787b68d5c92ea9de2d442a4a6c"
REC_ID=""

# The address where your public IP comes from
# Copy the public_ip.php from this folder to any webserver or just use mine
GET_IP_FROM="http://arne.me/owndns/ip"

# The file to log IPs to
LOGFILE="owndns.log";


# Logs date and IP
function log() {
    # Log date and IP to logfile
    echo -e "$(date +%Y-%m-%d) $IP" >> "$LOGFILE"
}

# Updates IP at registrar
function update_ip() {
    # Get current IP
    IP=$(curl -s -L $GET_IP_FROM)
    LAST_IP=0

    # Get last IP if logfile exists
    if [ -e "$LOGFILE" ]; then
        LAST_IP=$(tail -1 $LOGFILE | cut -d' ' -f2)
    fi

    # Check if the IP is new
    if [ "$IP" != "$LAST_IP" ]; then
        # We have a new IP!
        # Let's update the registrar and log the IP

        case $REGISTRAR in
            0)
                # iwantmyname
                # We don't need to provide &myip because it will take the remote, if none is set
                curl -s -u "$EMAIL:$PASSWORD" \
                  "https://iwantmyname.com/basicauth/ddns?hostname=$DOMAIN"
                log ;;
            1)
                # CloudFlare
                curl -s "https://www.cloudflare.com/api_json.html" \
                  -d "a=rec_edit" \
                  -d "tkn=$TOKEN" \
                  -d "id=$REC_ID" \
                  -d "email=$EMAIL" \
                  -d "z=$DOMAIN" \
                  -d "type=A" \
                  -d "name=$DOMAIN" \
                  -d "content=$IP" \
                  -d "service_mode=1" \
                  -d "ttl=1"
                log ;;
            *)
                echo "Registrar $REGISTRAR not supported!" ;;
        esac
    else
        echo "Error: The IP address $IP is already set up."
    fi
}

# Check if --force or -f is appendet
# If yes, update registrar, otherwise ask first
if [ "$1" == "--force" -o "$1" == "-f" ]; then
    update_ip
else
    read -p "This may change the IP address for your domain. Are you sure? (y/n) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        update_ip
    fi
fi

# Unset functions
unset log
unset update_ip
