FROM iojs:3.1.0
MAINTAINER Takaya Kobayashi <kobayashi_takaya@cyberagent.co.jp>

ADD . /app
RUN cd /app && npm install

CMD ["/app/node_modules/.bin/lsc", "/app/index.ls"]
