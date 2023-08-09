ARG BUILD_FROM
FROM $BUILD_FROM AS RUNNING

RUN apk update && \
    apk add --no-cache \
		'rsync' \
		'coreutils' \
		'curl'

COPY root /
RUN chmod a+x /run.sh
ENTRYPOINT [ "/run.sh" ]

