FROM node:20 AS builder
WORKDIR /opt/server
COPY package.json .
RUN npm install
COPY *.js .

FROM node:20.18.0-alpine3.20
WORKDIR /opt/server
RUN addgroup -S expense && adduser -S expense -G expense
COPY --from=builder /opt/server /opt/server
RUN chown -R expense:expense /opt/server
EXPOSE 8080
USER expense
CMD ["node", "index.js"]

# ENV DB_HOST="mysql"