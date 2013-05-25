#!/bin/bash

# Selected registrar
# 0 => iwantmyname
# 1 => CloudFlare
REGISTRAR="0"

# Domain to be updated
DOMAIN=""

# Authentification for registrar
EMAIL=""
PASSWORD=""
TOKEN=""
REC_ID=""

# The address where your public IP comes from
# Copy the public_ip.php from this folder to any webserver or just use mine
GET_IP_FROM="http://arne.me/owndns/ip"

# The file to log IPs to
LOGFILE="owndns.log";
