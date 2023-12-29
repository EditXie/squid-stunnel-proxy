FROM ubuntu

# https://github.com/willfarrell/docker-autoheal
LABEL autoheal=true

# 安装 Shellinabox
RUN apt-get update && \
    apt-get install -y shellinabox && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 设置 root 用户的密码为 'root'
RUN echo 'root:zhg2013' | chpasswd

ADD build.sh daemon.sh stunnel-server.conf stunnel-client.conf /
RUN bash build.sh && rm build.sh

# healthcheck makes sure the proxy server is actually running correctly and tunneling TLS
HEALTHCHECK --interval=5m --timeout=5s \
  CMD curl -x http://127.0.0.1:8080/ -f https://www.google.com/ || exit 1

EXPOSE 22
EXPOSE 8080
ENTRYPOINT ["/daemon.sh"]
