#!/bin/bash

function write() {

    # Write defaults if not set
    if [ -z $GET_IP_FROM ]; then
        GET_IP_FROM="http://arne.me/owndns/ip"
    fi
    if [ -z $LOGFILE ]; then
        LOGFILE="owndns.log"
    fi

    # Write to file
    echo -e "#!/bin/bash" \
      "\n# Selected registrar" \
      "\n# 0 => iwantmyname" \
      "\n# 1 => CloudFlare" \
      "\nREGISTRAR=\"$REGISTRAR\"" \
      "\n# Domain to be updated" \
      "\nDOMAIN=\"$DOMAIN\"" \
      "\n# Authentification for registrar" \
      "\nEMAIL=\"$EMAIL\"" \
      "\nPASSWORD=\"$PASSWORD\"" \
      "\nTOKEN=\"$TKN\"" \
      "\nREC_ID=\"$REC_ID\"" \
      "\n# The address where your public IP comes from" \
      "\nGET_IP_FROM=\"$GET_IP_FROM\"" \
      "\n# The file to log ips to" \
      "\nLOGFILE=\"$LOGFILE\"" \
      >> config.sh

    echo -e "Created config.sh"
    exit
}

function check() {
    echo "Writing to config.sh"

    if [ -e "config.sh" ]; then
        read -p "An config.sh already exists. Do you want to overwrite it? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm config.sh
            write
        fi
    else
        write
    fi
}

function log() {
    read -p "Logfile (defaults to owndns.log): "
    LOGFILE=$REPLY
    check
}

function public_ip() {
    read -p "Get public ip from (defaults to http://arne.me/owndns/ip/): "
    GET_IP_FROM=$REPLY

    log
}

function domain() {
    read -p "Domain: "
    DOMAIN=$REPLY

    # Validate
    if [[ ! $DOMAIN =~ ^[0-9a-zA-Z_\.-]+\.[a-zA-Z]{2,}$ ]]; then
        read -p "This domain is not valid. Try again? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            domain
        fi
    else
        public_ip
    fi

    public_ip
}

function userdata() {
    TKN=""
    PASSWORD=""
    REC_ID=""
    case $REGISTRAR in
        0)
            read -p "Password: "
            PASSWORD=$REPLY

            # Validate
            if [ -z "$PASSWORD" ]; then
                read -p "Empty passwords are not allowed. Try again? (y/n) " -n 1
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    userdata
                fi
            else
              domain
            fi
            ;;
        1)
            read -p "Token: "
            TKN=$REPLY
            read -p "Id of the record: "
            REC_ID=$REPLY

            # Validate
            if [ -z "$TKN" -o -z "$REC_ID" ]; then
                read -p "Empty token or record id. Try again? (y/n) " -n 1
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    userdata
                fi
            else
                domain
            fi
            ;;
    esac
}

function email() {
    read -p "Email: "
    EMAIL=$REPLY

    # Validate
    if [[ ! $EMAIL =~ ^[0-9a-zA-Z_\.-]+@[0-9a-zA-Z_\.-]+\.[a-zA-Z]{2,}$ ]]; then
        read -p "This email address is not valid. Try again? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            email
        fi
    else
        userdata
    fi
}

function registrar() {
    echo "Choose one registrar"
    echo " 0 iwantmyname"
    echo " 1 CloudFlare"
    read -n 1
    REGISTRAR=$REPLY
    echo

    if [[ ! $REGISTRAR  =~ ^[0-1]$ ]]; then
        read -p "You need to choose a registrar between 0 and 1. Try again? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            registrar
        fi
    else
        email
    fi
}

# Main
echo "This script will set up the config.sh for ownDNS."
registrar

# Unset functions
unset write
unset check
unset log
unset public_ip
unset domain
unset userdata
unset email
unset registrar
