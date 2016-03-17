FROM ubuntu:wily
MAINTAINER platforms@digital.justice.gov.uk

# APT packages setup
RUN apt-get update \
    && apt-get install -y \
        cron \
        tsung \
        s3cmd \
        wget \
        ssh

RUN ssh-keygen -N "" -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    echo "Port 22" > /root/.ssh/config && \
    echo "StrictHostKeyChecking no" >> /root/.ssh/config && \
    echo "UserKnownHostsFile /dev/null" >> /root/.ssh/config

COPY run-tsung.sh /usr/local/bin
ENV ERL_EPMD_PORT=4369
ENTRYPOINT ["run-tsung.sh"]

