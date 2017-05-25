FROM ruby:2.3.4

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Add yarn's package repository (from <https://yarnpkg.com/en/docs/install#linux-tab>)
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update --assume-yes

# to get latest npm for phantomjs
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -

RUN apt-get install --assume-yes \
    build-essential nodejs \
    qt5-default libqt5webkit5-dev \
    xvfb \
    gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x \
    yarn

# for phantom js (for jasmine tests for example)  == depends on nodejs
RUN npm install -g phantomjs-prebuilt
