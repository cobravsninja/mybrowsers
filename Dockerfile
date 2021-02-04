FROM debian:10

RUN apt-get update && apt-get upgrade -y && \
  apt-get -y install xauth firefox-esr chromium && \
  apt-get clean && rm -rf /var/lib/apt/lists/* && \
  groupadd -g 1000 user && \
  useradd -s /bin/bash -m -u 1000 -g user user && \
  echo "user:123" | chpasswd

WORKDIR /home/user
