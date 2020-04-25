FROM debian:latest as builder

RUN apt update && \
    apt install -y \
      dirmngr \
      wget

RUN wget -O fr24feed.tgz https://repo-feed.flightradar24.com/rpi_binaries/fr24feed_1.0.25-3_armhf.tgz
RUN tar xzf fr24feed.tgz

FROM debian:latest

RUN apt update && \
    apt install -y \
      dirmngr \
      libcap2-bin \
      iputils-ping \
      ca-certificates

COPY --from=builder /fr24feed_armhf/fr24feed /usr/bin/fr24feed
RUN ["chmod", "+x", "/usr/bin/fr24feed"]

COPY run.sh /run.sh
RUN ["chmod", "+x", "/run.sh"]

ENTRYPOINT ["/run.sh"]
