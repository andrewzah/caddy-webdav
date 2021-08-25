caddy_version := '2.4.3'

build v=caddy_version:
  docker build . \
    --build-arg "CADDY_VERSION={{v}}" \
    -t "andrewzah/caddy-webdav:{{v}}-alpine3.13"

push v=caddy_version:
  just build "{{v}}"
  docker push "andrewzah/caddy-webdav:{{v}}-alpine3.13"
