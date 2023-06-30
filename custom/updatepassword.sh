#!/bin/bash

USER=${1}
PASSWORD=${2}

echo "${USER}:${PASSWORD}" | chpasswd \
  && dump-user.sh
