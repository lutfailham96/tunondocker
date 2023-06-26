# TunOnDocker
Disposable proxy tunnel on top of Docker

## Prerequisites
- Docker

## Firewall
Makes sure you have open firewall on this ports
- 80 (http)
- 443 (https)
- 7300 (udpgw)

## Quick start
Run `tunondocker` with single command
```shell
docker run \
    --rm \
    -it \
    --name tunondocker \
    -p 80:80 \
    -p 443:443 \
    -p 8442:442 \
    -p 7300:7300 \
    lutfailham/tunondocker:latest
```

## Create tunnel user
```shell
docker exec -it tunondocker createuser.sh <USERNAME> <PASSWORD>
```

## Environment variables
```
# log settings
GTPT_WS_LOGLEVEL=[1-5]
GTPT_PROXY_LOGLEVEL=[1-5]
```

## Build your own container image
```shell
docker build -t tunondocker:latest .
```

## Run your own container image
```shell
docker run \
    --rm \
    -it \
    --name tunondocker \
    -p 80:80 \
    -p 443:443 \
    -p 8442:442 \
    -p 7300:7300 \
    tunondocker:latest
```

## References
- go-tcp-proxy-tunnel (WebSocket webserver & proxy): https://github.com/lutfailham96/go-tcp-proxy-tunnel
- Dropbear SSH: https://github.com/mkj/dropbear
- BadVPN (tun2socks & udpwg): https://github.com/ambrop72/badvpn
- Docker: https://www.docker.com