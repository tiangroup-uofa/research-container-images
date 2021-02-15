FROM linuxserver/openssh-server

# Add openconnect vpn
ENV  USER_NAME=user

RUN apk add --update \
	openconnect &&\
	rm -rf /var/cache/apk/*
COPY /config/custom-cont-init.d /config/custom-cont-init.d

# First delete temp backup files
RUN rm -f /config/custom-cont-init.d/*~ &&\
	chmod +x /config/custom-cont-init.d/*.sh
