FROM iojs:3.1.0
MAINTAINER jigsaw <m@jgs.me>

ADD . /app
RUN cd /app && npm install

CMD ["/app/node_modules/.bin/lsc", "/app/index.ls"]
