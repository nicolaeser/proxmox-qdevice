FROM debian:trixie-slim

# 03.02.2026

LABEL maintainer="Nico Laeser"
LABEL description="Create a virtual qdevice for Proxmox Cluster"

RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    corosync-qnetd \
    corosync-qdevice \
    openssh-server \
    supervisor \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/sshd /var/log/supervisor \
    && apt-get -y autoremove \
    && apt-get clean

# Allow Root Login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Set default root password to 'root'
RUN echo 'root:root' | chpasswd

COPY supervisord.conf /etc/supervisord.conf
COPY adjust-root-pw.sh /usr/local/bin/adjust_root_password.sh

RUN chown root:root /usr/local/bin/adjust_root_password.sh \
    && chmod 755 /usr/local/bin/adjust_root_password.sh

EXPOSE 22
EXPOSE 5403

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
