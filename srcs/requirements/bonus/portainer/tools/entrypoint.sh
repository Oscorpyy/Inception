#!/bin/sh

SECRET_FILE="/run/secrets/portainer_password"

if [ -f "$SECRET_FILE" ]; then
    PLAIN_PASSWORD=$(cat "$SECRET_FILE" | tr -d '\n')

    HASHED_PASSWORD=$(htpasswd -nbBC 10 admin "$PLAIN_PASSWORD" | cut -d: -f2)

    echo "Portainer: admin password loaded from secret."
    exec /opt/portainer/portainer \
        --bind-https ":9443" \
        --data /data \
        --admin-password "$HASHED_PASSWORD"
else
    echo "WARNING: No password secret found, starting with first-login setup."
    exec /opt/portainer/portainer \
        --bind-https ":9443" \
        --data /data
fi
