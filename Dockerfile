FROM ubuntu:wily
MAINTAINER platforms@digital.justice.gov.uk

# APT packages setup
RUN apt-get update \
    && apt-get install -y \
        git \
        s3cmd \
        wget \
        ssh \
        build-essential \
        erlang-base \
        erlang-ssl \
        erlang-xmerl \
        erlang-inets \
        erlang-mnesia \
        erlang-os-mon \
        erlang-runtime-tools \
        erlang-snmp \
        erlang-dev \
        python-matplotlib \
        libtemplate-perl \
        gnuplot 
RUN wget http://tsung.erlang-projects.org/dist/tsung-1.6.0.tar.gz \
    && tar -xvf tsung-1.6.0.tar.gz \
    && cd tsung-1.6.0 \
    && ./configure && make && make install
RUN ssh-keygen -N "" -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    echo "Port 22" > /root/.ssh/config && \
    echo "StrictHostKeyChecking no" >> /root/.ssh/config && \
    echo "UserKnownHostsFile /dev/null" >> /root/.ssh/config

COPY run-tsung.sh /usr/local/bin
ENV ERL_EPMD_PORT=4369
ENTRYPOINT ["run-tsung.sh"]
