#!/bin/bash
# This script initializes the env variables that could be used for vast.ai services
SCRIPT_NAME=$(realpath "$0")
SCRIPT_PATH=$(dirname ${SCRIPT_NAME})
source ${SCRIPT_PATH}/vastai.env
if ! [ -z "$RCLONE_CONF_BASE64" ]
then
    if $(command -v rclone >/dev/null)
    then
	mkdir -p /home/$NB_USER/.config/rclone
	echo $RCLONE_CONF_BASE64 | base64 -d >> /home/$NB_USER/.config/rclone/rclone.conf
	fix-permissions /home/$NB_USER/.config
    fi
fi
unset RCLONE_CONF_BASE64
echo GITHUB_TOKEN=${GITHUB_TOKEN} >> /etc/environment
echo WANDB_API_KEY=${WANDB_API_KEY} >> /etc/environment

if $(command -v start-notebook.py >/dev/null)
then
    start-notebook.py --IdentityProvider.token=${JUPYTER_LAB_TOKEN} &
fi
unset JUPYTER_LAB_TOKEN
