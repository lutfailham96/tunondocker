#!/bin/bash

USER=${1}
PASSWORD=${2}

echo "${USER}:${PASSWORD}" | adduser -s /bin/false -S ${USER} \
  && echo "${USER}:${PASSWORD}" | chpasswd
