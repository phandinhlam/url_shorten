FROM ruby:2.6.5

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libnotify-dev npm && \
    rm -rf /var/lib/apt/lists/*

ARG APP_DIR=/usr/src/app

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/${BUNDLE_PATH}/bin \
    GEM_HOME=/${BUNDLE_PATH}

ENV PATH="${BUNDLE_BIN}:${PATH}"

WORKDIR $APP_DIR

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g yarn

COPY . $APP_DIR/

RUN chmod +x init.sh
RUN chmod +x ./entrypoints/docker-entrypoint.sh
RUN ./init.sh
RUN gem install bundler
