FROM debian:trixie-slim

LABEL maintainer="Nico Laeser"
LABEL description="Create a virtual qdevice for Proxmox Cluster"

RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    corosync-qnetd \
    corosync-qdevice \
    openssh-server \
    supervisor \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/sshd /var/log/supervisor
    && apt -y autoremove \
    && apt clean all
    
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 22
EXPOSE 5403

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
