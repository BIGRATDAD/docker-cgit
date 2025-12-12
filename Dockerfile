#
#
# cgit Docker Container

FROM rockylinux:9
LABEL MAINTAINER="RATDAD <lambda@disroot.org>"

# Update everything; install dependencies.
RUN dnf -y update && dnf -y upgrade \
    && dnf install -y git gcc make openssl-devel zlib-devel zip \
    highlight httpd pip \
    && dnf clean all

# Install cgit.
RUN git clone https://git.zx2c4.com/cgit
ADD cgit.conf cgit
RUN cd cgit \
    && git submodule init \
    && git submodule update \
    && make NO_LUA=1 \
    && make install \
    && cd .. \
    && rm -rf cgit

# Configure.
ADD etc/cgitrc /etc/cgitrc
ADD etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf

# Add helper scripts.
COPY opt/ /opt
RUN chmod +x /opt/*

# Entrypoint.
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

# You SHOULD run this behind a reverse proxy.
# Thus, 443 isn't being exposed.
EXPOSE 80
ENTRYPOINT [ "/entrypoint.sh" ]
