FROM alpine

RUN apk update && apk add grafana --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache

ARG GRAF_USER

ARG GRAF_PASS

COPY srcs/grafana.ini /usr/share/grafana/conf/custom.ini

COPY srcs/launch_grafana.sh /launch_grafana.sh

RUN sed -i "s/__GRAF_USER__/$GRAF_USER/g" /usr/share/grafana/conf/custom.ini \
	&& sed -i "s/__GRAF_PASS__/$GRAF_PASS/g" /usr/share/grafana/conf/custom.ini

EXPOSE 3000

WORKDIR /

ENTRYPOINT ["/bin/sh"]

CMD ["/launch_grafana.sh"]
