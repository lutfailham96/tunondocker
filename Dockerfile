FROM alpine:3.18

WORKDIR /root

ENV GTPT_ENABLED=true \
    GTPT_PROXY_LISTEN=0.0.0.0:8082 \
    GTPT_PROXY_LOGLEVEL=1 \
    GTPT_WS_DROPBEAR_ADDRESS=127.0.0.1:8082 \
    GTPT_WS_SNI=localhost \
    GTPT_WS_LOGLEVEL=1 \
    DROPBEAR_ENABLED=true \
    DROPBEAR_HOST=0.0.0.0 \
    DROPBEAR_PORT=442 \
    BADVPN_UDPGW_ENABLED=true \
    BADVPN_UDPGW_LOGLEVEL=1 \
    BADVPN_UDPGW_HOST=0.0.0.0 \
    BADVPN_UDPGW_PORT=7300

# Install prerequisites
RUN apk add --no-cache \
        bash \
        screen \
        openssl
# Generate GTPT self-signed certificate & key
RUN openssl req \
        -newkey rsa:4096 \
        -nodes \
        -keyout /etc/gtpt.key \
        -x509 \
        -days 3650 \
        -out /etc/gtpt.cert \
        -subj "/C=ID/ST=Jawa Barat/L=Jakarta/O=IT/CN=localhost"
# Allow valid shell login
RUN echo /bin/false >> /etc/shells

# Dropbear
COPY ./dropbear/dropbear /usr/local/sbin/
COPY ./dropbear/dropbear.8 /usr/local/share/man/man8/
COPY ./dropbear/dbclient /usr/local/bin/
COPY ./dropbear/dbclient.1 /usr/local/share/man/man1/
COPY ./dropbear/dropbearkey /usr/local/bin/
COPY ./dropbear/dropbearkey.1 /usr/local/share/man/man1/
COPY ./dropbear/dropbearconvert /usr/local/bin/
COPY ./dropbear/dropbearconvert.1 /usr/local/share/man/man1/
# GTPT
COPY ./gtpt/go-tcp-proxy-tunnel /usr/local/bin/
COPY ./gtpt/go-ws-web-server /usr/local/bin/
# Badvpn
COPY ./badvpn/badvpn.7 /usr/local/share/man/man7/
COPY ./badvpn/badvpn-server /usr/local/bin/
COPY ./badvpn/badvpn-server.8 /usr/local/share/man/man8/
COPY ./badvpn/badvpn-client /usr/local/bin/
COPY ./badvpn/badvpn-client.8 /usr/local/share/man/man8/
COPY ./badvpn/badvpn-flooder /usr/local/bin/
COPY ./badvpn/badvpn-tun2socks /usr/local/bin/
COPY ./badvpn/badvpn-tun2socks.8 /usr/local/share/man/man8/
COPY ./badvpn/badvpn-udpgw /usr/local/bin/
COPY ./badvpn/badvpn-ncd /usr/local/bin/
COPY ./badvpn//badvpn-ncd-request /usr/local/bin/
# Custom scripts
COPY ./createuser.sh /usr/local/bin/
# Entrypoint
COPY docker-entrypoint.sh /

EXPOSE 80 442 443 8082 7300

CMD ["/docker-entrypoint.sh"]
