FROM ubuntu-dev:18.04

RUN apt-get update
RUN apt install -y gcc-mingw-w64 pkg-config libgtk2.0-dev

COPY get_depends.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/get_depends.sh
ENTRYPOINT ["/usr/local/bin/get_depends.sh"]
