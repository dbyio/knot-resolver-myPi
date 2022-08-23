FROM alpine:3.12

RUN apk update && apk add --no-cache knot-resolver bash && \
  rm -rf /var/cache/apk/* /var/cache/knot-resolver
COPY docker/entrypoint.sh /
COPY conf/kresd.conf.tmpl /etc

USER kresd
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
