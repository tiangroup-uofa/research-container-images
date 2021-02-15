#!/usr/bin/with-contenv bash

if [[ -z "$OPENCONNECT_USERNAME" ]]
then
    return -1
fi

if [[ -z "$OPENCONNECT_SERVER" ]]
then
    return -1
fi

if [[ -z "$OPENCONNECT_PW" ]]
then
    return -1
fi
  
echo "$OPENCONNECT_PW" | openconnect -b --disable-ipv6 -u ${OPENCONNECT_USERNAME} --passwd-on-stdin ${OPENCONNECT_SERVER}
