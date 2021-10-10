FROM alpine:latest
RUN apk add --no-cache \
    python3 \
    py3-pip \
    bash \
    curl \
    pspg \
    postgresql-client \
    libevent \
    libpq

RUN  apk add --no-cache --virtual .build-deps \
    python3-dev \
    postgresql-dev \
    libevent-dev \
    musl-dev \
    gcc

RUN python3 -m ensurepip && \
    pip3 install --upgrade pip \
    && pip3 install awscli \
    && pip3 install psycopg2-binary \
    && pip3 install pgcli

RUN rm -rf /var/chache/apk/*

CMD tail -f /dev/null