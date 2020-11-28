FROM ruby:2.3.1

RUN apt-get update && apt-get upgrade -y && apt-get install  -y --no-install-recommends \
      # for locale
      locales \
      # for rails-erd
      graphviz \
      # for mysqldump
      mysql-client \
    && rm -rf /var/lib/apt/lists/* \
    # Phantomjs
    && mkdir /tmp/phantomjs \
    && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
            | tar -xj --strip-components=1 -C /tmp/phantomjs \
    && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin \
    # Locale
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ARG BUNDLE_GITHUB__COM
ARG APP_HOME

ENV LANG en_US.utf8

RUN git config --global user.email "docker@f-scratch.com" \
    && git config --global user.name "development docker"

RUN git clone https://${BUNDLE_GITHUB__COM}@github.com/f-scratch/zelda-platform.git $APP_HOME

WORKDIR $APP_HOME

ENV BUNDLE_APP_CONFIG=.bundle \
    BUNDLE_JOBS=2 \
    BUNDLE_PATH=$APP_HOME/vendor/bundle
