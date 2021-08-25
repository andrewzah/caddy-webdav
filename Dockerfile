FROM golang:1.15.7-alpine3.13 as caddy-builder

RUN apk add curl ca-certificates git

ARG CADDY_VERSION="2.3.0"
ARG CADDY_ARGS="--with github.com/mholt/caddy-webdav"

WORKDIR /build
RUN git clone https://github.com/caddyserver/xcaddy.git

RUN cd xcaddy/cmd/xcaddy \
  && go build \
  && ./xcaddy build "v$CADDY_VERSION" $CADDY_ARGS \
  && mv caddy /build/caddy

FROM andrewzah/base-alpine:3.13

RUN apk add --no-cache curl ca-certificates

COPY ./root/ /
COPY --from=caddy-builder /build/caddy /usr/bin/caddy

EXPOSE 6969
HEALTHCHECK CMD curl -sSf http://localhost:6969 2>&1 | grep -Eq "200|401"
