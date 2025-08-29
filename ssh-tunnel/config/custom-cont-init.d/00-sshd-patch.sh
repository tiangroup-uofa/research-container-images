#!/usr/bin/with-contenv bash

# Update the sshd config to allow TCP & X11 forwarding
sed -i "/^AllowTcpForwarding/c\AllowTcpForwarding yes" /etc/ssh/sshd_config
sed -i "/^X11Forwarding/c\X11Forwarding yes" /etc/ssh/sshd_config
sed -i "/^GatewayPorts/c\#GatewayPorts yes" /etc/ssh/sshd_config
