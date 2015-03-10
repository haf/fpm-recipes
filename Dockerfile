FROM haaf/centos-builder

MAINTAINER Henrik Feldt <henrik@haf.se>

COPY . /home/builder

USER builder
WORKDIR /home/builder
RUN source /home/builder/.bash_profile

ENTRYPOINT /usr/bin/env bundle exec rake
CMD -T
