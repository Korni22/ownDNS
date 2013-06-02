#!/bin/bash

# Logs date and IP
function log() {
    # Log date and IP to logfile
    echo -e "$(date +%Y-%m-%d) $IP" >> "$LOGFILE"
}

# Updates ip at registrar
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
        # We have a new IP address
        case $REGISTRAR in
            0)
                # iwantmyname
                # We don't need to provide &myip because it will take the remote, if none is set
                RETURN=$(curl -s \
                  -u "$EMAIL:$PASSWORD" \
                  "https://iwantmyname.com/basicauth/ddns?hostname=$DOMAIN")

                case $RETURN in
                  "good $IP")
                    echo "Success"
                    ;;
                  "badauth.")
                    echo "Bad auth, check your config.sh"
                    ;;
                  "")
                    echo "Curl failed, check your internet"
                    ;;
                  *)
                    echo "An unknown error occured"
                  ;;
                esac
                log
                ;;
            1)
                # CloudFlare
                RETURN=$(curl -s \
                  "https://www.cloudflare.com/api_json.html" \
                  -d "a=rec_edit" \
                  -d "tkn=$TOKEN" \
                  -d "id=$REC_ID" \
                  -d "email=$EMAIL" \
                  -d "z=$DOMAIN" \
                  -d "type=A" \
                  -d "name=$DOMAIN" \
                  -d "content=$IP" \
                  -d "service_mode=1" \
                  -d "ttl=1")

                if [[ $RETURN =~ \"result\":\"success\" ]]; then
                  echo "Success"
                elif [[ $RETURN =~ \"err_code\":\"E_UNAUTH\" ]]; then
                  echo "Bad auth, check your config.sh"
                elif [[ $RETURN =~ \"result\":\"error\" ]]; then
                  echo "An unknown error occured"
                elif [ -z $RETURN ]; then
                  echo "Curl failed, check your internet"
                fi

                log
                ;;
            *)
                echo "Registrar $REGISTRAR not supported!"
                ;;
        esac
    else
        echo "The IP address $IP is already set up."
    fi
}

# Load config
if [ -e "config.sh" ]; then
    # Include config.sh
    source config.sh

    # Check if --force or -f is appended
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
else
    echo "No config file found."
    echo "Run setup-config.sh or rename config-template.sh to config.sh and fill in your data."
fi

# Unset functions
unset log
unset update_ip
