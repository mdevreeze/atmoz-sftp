FROM debian:bullseye
MAINTAINER Adrian Dvergsdal [atmoz.net]

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

COPY files/sshd_config /etc/ssh/sshd_config
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /

# custom changes
COPY files/entrypoint2 /
RUN mkdir -p /home/ursuser/.ssh/keys
COPY keys/* /home/ursuser/.ssh/keys/
COPY hostkeys/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key 
COPY hostkeys/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key 
# custom changes end

EXPOSE 22

# use custom entrypoint
ENTRYPOINT ["/entrypoint2"]
