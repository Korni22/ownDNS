# ownDNS
An open-source alternative to DynDNS.

This was originally created to be ran on a [Fritz!Box](http://en.wikipedia.org/wiki/FRITZ!Box), since the popular DynDNS
providers like [DynDNS](http://dyn.com/dns/) and [No-IP](http://www.noip.com/) are becoming more and more difficult to
use for free, but it *should* run on almost every router that is able to provide a shell.

# Installation
Rename `config-template.sh` to `config.sh` and fill in your data (or run `setup-config.sh`).
Then copy the scripts to any Unix-machine (even your router) and let it run at specific intervals (I'd recommend 1 min).

## Config
All configuration lies in `config.sh`. Read registrar-specific config at your [registrar](#supported-registrars).

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
CloudFlare only supports updating a record with it's id. 
To determine the ID of the record you want to use, you can either:
- Use the script at [server/cloudflare](server/cloudflare). (This doesn't need to be on a webserver, you can also run it locally (e.g. via [MAMP](http://www.mamp.info/)).)

- You can also make an [API call](http://www.cloudflare.com/docs/client-api.html#s3.3) to manually find out the id.

### Data
- `REGISTRAR`: 1
- `DOMAIN`: The domain to update
- `EMAIL`: The email address you've registered with at your registrar
- `TOKEN`: The API token (get it [here](https://www.cloudflare.com/my-account))
- `REC_ID`: The id of the a-record to update

# On the public ip
You have to get your public ip address and this is only possible via a remote webserver. When you trust me, just use `http://arne.me/owndns/ip`. But if you don't, you can copy the folder [server/ip](server/ip) to any PHP webserver and use it's address as `GET_IP_FROM`.

# Cronjob
If you're not familiar with cronjobs, just run `crontab -e` from your command line and add this line:
```crontab
1 * * * * /path/to/owndns.sh --force
```

#FAQ
- Q: Dude, $REGISTRAR is not supported, what the f*ck?
- A: Well, unfortunately, not every registrar has an [API](http://en.wikipedia.org/wiki/API) that we can use, so we would have to *manually* parse the web page, log in, change everything, etc. Even if we would do this (which is a humongous) amount of work, the slightest change on the web page will break the script.

- Q: But, dude, my registrar *has* an [API](http://en.wikipedia.org/wiki/API)!
- A: *Awesome*! Then just [open an issue](https://github.com/abahlo/owndns/issues/new) like this :
    'FR: $YOURREGISTRAR'
and please *do* link your registrar's API documentation :)

- Q: But, dude, my question is not here!
- A: No problem, *brah*, just contact me [via e-mail](http://scr.im/korni)

## License
This project is licensed under the MIT License, for more information see [LICENSE.txt](LICENSE.txt).
