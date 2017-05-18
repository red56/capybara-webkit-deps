FROM ruby:2.3.4

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update --assume-yes

RUN apt-get install --assume-yes \
    build-essential nodejs \
    qt5-default libqt5webkit5-dev \
    xvfb \
    gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
