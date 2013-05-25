# OwnDNS
An alternative to Dyndns.

# Installation
Just fill in your data at `owndns.sh`, copy the script to any Unix-machine (even your router) and let it run at specific intervals (I'd recommend 1 min).

## General Data
Read specific data at your [registrar](#supported-registrars).

- `REGISTRAR`: The ID of the registrar (more at [supported registrars](#supported-registars))
- `GET_IP_FROM`: The internet address to get your public IP from ([on the public ip](#on-the-public-ip))
- `LOGFILE`: The name of the file where the ip changes will be logged

# Supported registrars
## iwantmyname
This one's easy.

### Data
- `REGISTRAR`: 0
- `DOMAIN`: The domain to update
- `EMAIL`: The email address you've registered with
- `PASSWORD`: Your password

## CloudFlare
CloudFlare only supports updating a record with it's id. Use the script at [server/cloudflare](server/cloudflare). This doesn't need to be on a webserver, you can also run it locally (e.g. via [MAMP](http://www.mamp.info/)).

You could also make an [API call](http://www.cloudflare.com/docs/client-api.html#s3.3) to manually find out the id.

### Data
- `REGISTRAR`: 1
- `DOMAIN`: The domain to update
- `EMAIL`: The email address you've registered with at your registrar
- `TOKEN`: The API token (get it [here](https://www.cloudflare.com/my-account))
- `REC_ID`: The id of the a-record to update (more at [CloudFlare](#cloudflare))

# On the public ip
You have to get your public ip address and this is only possible via a remote webserver. When you trust me, just use `http://arne.me/owndns/ip`. But if you don't, you can copy the folder [server/ip](server/ip) to any PHP webserver and use it's address as `GET_IP_FROM`.

# Cronjob
If you're not familiar with cronjobs, just run `crontab -e` from your command line and add this line:
```crontab
1 * * * * /path/to/owndns.sh --force
```
