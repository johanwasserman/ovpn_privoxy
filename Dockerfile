FROM alpine:latest
RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates privoxy openvpn runit

MAINTAINER alturismo alturismo@gmail.com

# Timezone (TZ)
RUN apk update && apk add --no-cache tzdata
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add Bash shell & dependancies
RUN apk add --no-cache bash busybox-suid su-exec

# OpenVPN Variables
ENV OPENVPN_FILE=Frankfurt.ovpn \
 LOCAL_NET=192.168.1.0/24

# Volumes
VOLUME /config

# Add Files
COPY Frankfurt.ovpn /
COPY logindata.conf /
COPY startups /startups

RUN find /startups -name run | xargs chmod u+x

# Add Expose Port
EXPOSE 8080

# Command
CMD ["runsvdir", "/startups"]
