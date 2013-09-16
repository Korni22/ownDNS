#!/bin/bash

# Selected registrar
# 0 => iwantmyname
# 1 => CloudFlare
REGISTRAR=""

# Domain to be updated
DOMAIN=""

# Authentification for registrar
EMAIL=""
PASSWORD=""
TOKEN=""
REC_ID=""

# The address where your public ip comes from
GET_IP_FROM="http://arne.me/owndns/ip"

# The file to log ips to
LOGFILE="owndns.log"
