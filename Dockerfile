FROM adjs/nodejs
MAINTAINER Scott Switzer <scott@switzer.org>

# Install Git in order to pull down our code
RUN       apt-get update
RUN       apt-get -y upgrade
RUN apt-get -y install git

# Get the source code and install
RUN cd /usr/src && git clone https://github.com/adjs/iodocs.git
WORKDIR /usr/src/iodocs
RUN npm install

# Get the config
RUN cp config.json.sample config.json

# Remove installation tools
RUN apt-get remove -y git

EXPOSE 3000

CMD forever start app.js
