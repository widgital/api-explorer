# Dockerfile for IODocs
#
# Run Instructions - DETACHED
# docker run --name iodocs --link redis:redis -d adjs/iodocs
#
# Run Instructions - INTERACTIVE
# docker run --name iodocs --link redis:redis --rm -i -t adjs/iodocs /bin/bash
#
# Build Instructions
# docker build -t adjs/iodocs --rm /home/core/share/code/adjs/iodocs

# Pull from the latest NodeJS release from Ad.js
FROM adjs/nodejs

# File Author / Maintainer
MAINTAINER Scott Switzer <scott@switzer.org>

# Install Git in order to pull down our code
RUN apt-get -y install git-core

# Get the source code and install
RUN cd /usr/src && git clone https://github.com/adjs/iodocs.git

# Set working directory to iodocs
WORKDIR /usr/src/iodocs

# Install dependencies for iodocs
RUN npm install

# Copy the config from the included sample
RUN cp config.json.sample config.json

# Configure to run on a socket
RUN sed -i 's#"port" : 3000,#"port" : 3000,\n    "socket" : "/tmp/iodocs.sock",#' config.json

# Make the owner of these files www-data (which will be running the node process)
RUN chown -R www-data:www-data ../iodocs

# Allow sockets created there to be used by others
RUN chmod 0777 /tmp
RUN su www-data -c 'echo 1 > /tmp/test.txt'

# Share the socket and set perms
VOLUME /tmp

# Share the config directory
VOLUME /etc/nginx/sites-enabled

# Place the Nginx proxy in the nginx config directory
ADD explorer.adjs.io.conf /etc/nginx/sites-enabled/explorer.adjs.io.conf

# Add the supervisord conf file
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the port (not needed if using socket)
# EXPOSE 3000

RUN chmod 0777 /tmp

CMD /usr/bin/supervisord -u www-data
