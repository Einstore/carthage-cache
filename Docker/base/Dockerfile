FROM swift:latest as builder

WORKDIR /app
COPY . /app

RUN apt-get update &&  apt-get install openssl libssl-dev libssh2-1-dev zlib1g-dev -y

