FROM debian:bullseye

RUN sed -i \
        's|^# deb http://snapshot|deb [check-valid-until=no] http://snapshot|g; s|^deb http://deb|# deb http://deb|g' \
        /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        apache2-utils \
    && rm -rf /var/lib/apt/lists/*

ARG PORTAINER_VERSION=2.21.5
RUN wget -q "https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz" \
        -O /tmp/portainer.tar.gz \
    && tar -xzf /tmp/portainer.tar.gz -C /opt/ \
    && rm -f /tmp/portainer.tar.gz \
    && chmod +x /opt/portainer/portainer

RUN mkdir -p /data

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
