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
    echo -e "#!/bin/bash\n" \
      "\r# Selected registrar" \
      "\r# 0 => iwantmyname" \
      "\r# 1 => CloudFlare" \
      "\rREGISTRAR=\"$REGISTRAR\"\n" \
      "\r# Domain to be updated" \
      "\rDOMAIN=\"$DOMAIN\"\n" \
      "\r# Authentification for registrar" \
      "\rEMAIL=\"$EMAIL\"" \
      "\rPASSWORD=\"$PASSWORD\"" \
      "\rTOKEN=\"$TOKEN\"" \
      "\rREC_ID=\"$REC_ID\"\n" \
      "\r# The address where your public IP comes from" \
      "\rGET_IP_FROM=\"$GET_IP_FROM\"\n" \
      "\r# The file to log ips to" \
      "\rLOGFILE=\"$LOGFILE\"" \
      >> config.sh

    echo -e "Created config.sh"
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
    read -p "Logfile (leave empty for owndns.log): "
    LOGFILE=$REPLY
    check
}

function public_ip() {
    read -p "Get public ip from (leave empty for http://arne.me/owndns/ip/): "
    GET_IP_FROM=$REPLY
    log
}

function domain() {
    read -p "Domain: "
    DOMAIN=$REPLY
    public_ip
}

function userdata() {
    # Read in userdata
    TKN=""
    PASSWORD=""
    case $REGISTRAR in
        0)
            read -p "Email: "
            EMAIL=$REPLY
            read -p "Password: "
            PASSWORD=$REPLY
            domain ;;
        1)
            read -p "Email: "
            EMAIL=$REPLY
            read -p "Token: "
            TKN=$REPLY
            read -p "Id of the record: "
            REC_ID=$REPLY
            domain ;;
        *)
            echo "Registrar #$REGISTRAR is not an option"
            ;;
    esac
}

function registrar() {
    # Read in registrar
    echo "Choose one registrar"
    echo " 0 iwantmyname"
    echo " 1 CloudFlare"
    read -n 1
    REGISTRAR=$REPLY
    echo
    userdata
}

echo "This script will set up the config.sh for ownDNS"
registrar

# Unset functions
unset write
unset check
unset log
unset public_ip
unset domain
unset userdata
unset registrar
