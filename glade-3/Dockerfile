FROM ubuntu-dev:18.04

RUN apt-get update
RUN apt install -y gnome-common gtk-doc-tools libglib2.0-dev libxml2-dev libgnomeui-dev libbonoboui2-dev \
	yelp-tools devhelp

RUN wget https://ftp.gnome.org/pub/GNOME/sources/glade3/3.8/glade3-3.8.6.tar.xz -O /home/docker/glade3_8.tar.xz
RUN tar -xf /home/docker/glade3_8.tar.xz -C /home/docker
RUN rm -f /home/docker/glade3_8.tar.xz

# build now
RUN cd /home/docker/glade3-3.8.6 && ./autogen.sh && make -j8 && make install
RUN ldconfig

# start dbus daemon
RUN dbus-uuidgen > /var/lib/dbus/machine-id
RUN mkdir -p /var/run/dbus
RUN dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address
RUN mkdir -p /home/docker/.local/share
RUN chown -R docker:docker /home/docker/.local/

CMD [ "glade-3" ]
