FROM ubuntu:18.04

RUN apt update && apt upgrade -y \
    && apt install -y build-essential libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev autoconf libsqlite3-dev tzdata nodejs npm

RUN VERSION=2.35.1 && SRC_DIR=git-${VERSION} && TAR_GZ=${SRC_DIR}.tar.gz && \
    curl -L -o ${TAR_GZ} https://github.com/git/git/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -xzvf ${TAR_GZ} && cd ${SRC_DIR} && make configure && ./configure --prefix=/usr/local && make && make install && \
    rm -rf ${SRC_DIR} ${TAR_GZ}

RUN IPATH=~/.rbenv && git clone https://github.com/rbenv/rbenv.git ${IPATH} && \
    mkdir -p ${IPATH}/plugins && \
    git clone https://github.com/rbenv/ruby-build.git ${IPATH}/plugins/ruby-build

ENV PATH=/root/.rbenv/bin:$PATH

RUN rbenv install 3.1.0 && rbenv global 3.1.0

ENV PATH=/root/.rbenv/shims:$PATH

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

RUN npm install -g yarn && yarn init

EXPOSE 3000

COPY ./Rakefile     .
COPY ./config.ru    .
COPY ./bin          bin
COPY ./config       config
COPY ./lib          lib
COPY ./public       public
COPY ./db           db
COPY ./app          app
COPY ./spec         spec

RUN apt purge -y build-essential libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev autoconf libsqlite3-dev


