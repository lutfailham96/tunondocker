#!/bin/bash

# go-tcp-proxy-tunnel
if [ ${GTPT_ENABLED:-true} = true ]; then
  echo "gtpt: starting proxy service ..."
  screen -AmdS gtpt-proxy go-tcp-proxy-tunnel \
    -l ${GTPT_PROXY_LISTEN:-0.0.0.0:8082} \
    -r 127.0.0.1:${DROPBEAR_PORT:-442} \
    -sv \
    -lv ${GTPT_PROXY_LOGLEVEL:-1}
  echo "gtpt: starting websocket webserver service ..."
  screen -AmdS gtpt-ws go-ws-web-server \
    -b ${GTPT_WS_DROPBEAR_ADDRESS:-127.0.0.1:8082} \
    -cert /etc/gtpt.cert \
    -key /etc/gtpt.key \
    -sni ${GTPT_WS_SNI:-localhost} \
    -lv ${GTPT_WS_LOGLEVEL:-1}
fi

# dropbear
if [ ${DROPBEAR_ENABLED:-true} = true ]; then
  if [ ! -f filename ]; then
    echo "dropbear: setup banner file ..."
    mkdir -p /etc/dropbear
    touch /etc/dropbear/banner
  else
    echo "dropbear: banner file exist, skipping ..."
  fi
  echo "dropbear: starting service ..."
  screen -L -Logfile /var/log/messages -AmdS dropbear dropbear -R -F -w -a -g -E -b /etc/dropbear/banner -p ${DROPBEAR_HOST:-0.0.0.0}:${DROPBEAR_PORT:-442}
fi

# badvpn-udpgw
if [ ${BADVPN_UDPGW_ENABLED:-true} = true ]; then
  echo "badvpn-udpgw: starting service ..."
  screen -AmdS badvpn-udpgw badvpn-udpgw \
    --loglevel ${BADVPN_UDPGW_LOGLEVEL:-1} \
    --listen-addr ${BADVPN_UDPGW_HOST:-0.0.0.0}:${BADVPN_UDPGW_PORT:-7300}
fi

tail -f /dev/null
