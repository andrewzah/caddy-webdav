FROM golang:1.15.7-alpine3.13 as caddy-builder

RUN apk add curl ca-certificates git

ENV CADDY_VERSION "v2.3.0"
ENV CADDY_ARGS "--with github.com/mholt/caddy-webdav"

WORKDIR /build
RUN git clone https://github.com/caddyserver/xcaddy.git

RUN cd xcaddy/cmd/xcaddy \
  && go build \
  && ./xcaddy build "$CADDY_VERSION" $CADDY_ARGS \
  && mv caddy /build/caddy

FROM andrewzah/base-alpine:3.13

RUN apk add curl ca-certificates

COPY ./root/ /
COPY --from=caddy-builder /build/caddy /usr/bin/caddy

EXPOSE 6969
HEALTHCHECK CMD curl --fail http://localhost:6969 || exit 1
