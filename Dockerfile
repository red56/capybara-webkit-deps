FROM cimg/ruby:2.5.8-browsers
# https://circleci.com/developer/images/image/cimg/ruby

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN sudo apt-get update --assume-yes
# need https transport because of dpkg I think
RUN sudo apt-get install --assume-yes apt-transport-https

RUN sudo apt-get install --assume-yes libsodium-dev

# install needed for nodejs
RUN sudo apt-get install --assume-yes python-minimal
# install needed for xvfb-run (for chrome)
RUN sudo apt-get install --assume-yes xvfb

# maybe ?
RUN sudo apt-get install --assume-yes xvfb build-essential unzip

# NODE Option 1
# Add for nodejs (from https://github.com/nodesource/distributions#manual-installation)
#ENV DISTRO="$(lsb_release -s -c)"
#RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
#RUN echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list
#RUN echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list
# RUN apt-get update && apt-get install  --assume-yes --no-install-recommends node

# Install node manually to get precise version
# NODE Option 2 ignore package management
#ENV VERSION=v10.15.3
#ENV DISTRO=linux-x64
#RUN mkdir -p /usr/local/lib/nodejs
#RUN curl -O https://nodejs.org/dist/$VERSION/node-$VERSION-$DISTRO.tar.xz
#RUN tar -xJvf node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs
#RUN ln -s /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/node /usr/bin/nodejs
#RUN ln -s /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/npm /usr/bin/npm

# NODE Option 3 use .deb from https://deb.nodesource.com/node_10.x/pool/main/n/nodejs/
ENV VERSION=10.15.3
RUN curl -O https://deb.nodesource.com/node_10.x/pool/main/n/nodejs/nodejs_${VERSION}-1nodesource1_amd64.deb
RUN sudo dpkg -i nodejs_${VERSION}-1nodesource1_amd64.deb
RUN sudo apt-get install -f

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN sudo apt-get update && sudo apt-get install  --assume-yes --no-install-recommends yarn
# FYI
RUN which nodejs
RUN nodejs -v
RUN which node
RUN node -v
RUN which yarn
RUN yarn -v

# https://github.com/ebidel/lighthouse-ci/blob/master/builder/Dockerfile
# https://qr.ae/TWhRta
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub |  sudo apt-key add - &&\
     sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' &&\
     sudo apt-get update &&\
     sudo apt-get install -y google-chrome-stable

RUN google-chrome --version || echo "could not find out chrome version"

# Install ChromeDriver.
RUN CHROME_DRIVER_VERSION=`curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE` &&\
    sudo wget -N https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ &&\
    sudo unzip ~/chromedriver_linux64.zip -d ~/ &&\
    sudo rm ~/chromedriver_linux64.zip &&\
    sudo mv -f ~/chromedriver /usr/local/bin/chromedriver &&\
    sudo chown root:root /usr/local/bin/chromedriver &&\
    sudo chmod 0755 /usr/local/bin/chromedriver
