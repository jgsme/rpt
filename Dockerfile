FROM node:5
MAINTAINER jigsaw <m@jgs.me>

ADD . /app
WORKDIR /app
RUN npm install

CMD ["npm", "start"]
