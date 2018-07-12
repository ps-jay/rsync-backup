FROM alpine

MAINTAINER Philip Jay <phil@jay.id.au>

ENV TZ Australia/Melbourne

# Remote server details
ENV USERNAME=""
ENV PASSWORD=""
ENV HOST=""
ENV PORT=""
ENV TARGET=""

# Space separated list of local directories
ENV LOCATIONS=""

# TCP port knock as required
ENV KNOCK1=""
ENV KNOCK2=""

RUN apk update \
 && apk upgrade \
 && apk add \
      bash \
      rsync \
      sshpass \
 && rm -rf /var/cache/apk/*

ADD backup.sh /usr/local/sbin/backup
RUN chmod +x /usr/local/sbin/backup

CMD ["/usr/local/sbin/backup"]
