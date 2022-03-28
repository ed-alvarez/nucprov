FROM ubuntu:latest

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update
RUN apt-get install -y libgconf-2-4 net-tools systemd sudo lsb-core x11-xserver-utils libqt5quickcontrols2-5 libqt5multimedia5 libqt5webengine5 libqt5quick5 libqt5qml5 libqca-qt5-2

RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

COPY assets/control-player-ubuntu.deb /tmp/
COPY assets/bsp /

RUN apt-get install -qy /tmp/control-player-ubuntu.deb
RUN /bsp start

CMD /opt/broadsign/suite/bsp/bin/start_bsp_undedicated.sh
