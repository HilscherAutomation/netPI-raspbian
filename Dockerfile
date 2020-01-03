#use armv7hf compatible base image
FROM balenalib/armv7hf-debian:buster-20191223

#dynamic build arguments coming from the /hook/build file
ARG BUILD_DATE
ARG VCS_REF

#metadata labels
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/HilscherAutomation/netPI-raspbian" \
      org.label-schema.vcs-ref=$VCS_REF

#enable cross compiling (comment out next line if built on Raspberry Pi) 
RUN [ "cross-build-start" ]

#version
ENV HILSCHERNETPI_RASPBIAN_VERSION 1.2.1

#labeling
LABEL maintainer="netpi@hilscher.com" \
      version=$HILSCHERNETPI_RASPBIAN_VERSION \
      description="Raspbian"

#environment variables
ENV USER=pi
ENV PASSWD=raspberry

RUN apt-get update \
 && apt-get install wget \
 && wget https://archive.raspbian.org/raspbian.public.key -O - | apt-key add - \
 && echo 'deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi' | tee -a /etc/apt/sources.list \
 && wget -O - http://archive.raspberrypi.org/debian/raspberrypi.gpg.key | sudo apt-key add - \
 && echo 'deb http://archive.raspberrypi.org/debian/ buster main ui' | tee -a /etc/apt/sources.list.d/raspi.list \
 && apt-get update  \
 && apt-get install -y openssh-server \
 && mkdir /var/run/sshd \
# && sed -i -e 's;#Port 22;Port 23;' /etc/ssh/sshd_config \ #Comment in if SSH port other than 22 is needed (22->23)
 && sed -i 's@#force_color_prompt=yes@force_color_prompt=yes@g' -i /etc/skel/.bashrc \
 && useradd --create-home --shell /bin/bash pi \
 && echo $USER:$PASSWD | chpasswd \
 && adduser $USER sudo \
 && groupadd spi \
 && groupadd gpio \
 && adduser $USER dialout \
 && adduser $USER cdrom \
 && adduser $USER audio \
 && adduser $USER video \
 && adduser $USER plugdev \
 && adduser $USER games \
 && adduser $USER users \
 && adduser $USER input \
 && adduser $USER spi \
 && adduser $USER gpio \
 && apt-get install -y --no-install-recommends \
                less \
                kmod \
                nano \
                net-tools \
                ifupdown \
                iputils-ping \
                usbutils \
                build-essential \
                python \
                unzip \
                info \
                htop \
                iptables \
                fbset \
                file \
                init \
                isc-dhcp-client  \
                isc-dhcp-common  \
                kbd \
                alsa-utils \
                apt-listchanges \
                apt-transport-https \
                apt-utils \
                avahi-daemon \
                bash-completion \
                bind9-host \
                bluez \
                bsdmainutils \
                cifs-utils \
                console-setup \
                console-setup-linux \
                cpio \
                crda \
                cron \
                dc \
                debconf-i18n \
                debconf-utils \
                device-tree-compiler \
                distro-info-data  \
                dmidecode \
                dosfstools \
                ed \
                fake-hwclock \
                fakeroot \
                gdb \
                dhcpcd5 \
                dphys-swapfile \
                groff-base \
                hardlink \
                iso-codes \
                keyutils \
                locales \
                logrotate \
                lsb-release \
                lua5.1 \
                luajit \
                man-db  \
                manpages \
                manpages-dev \
                ncdu \
                ncurses-term \
                netcat-openbsd \
                netcat-traditional \
                nfs-common \
                openresolv \
                paxctld \
                pkg-config \
                policykit-1 \
                rfkill \
                rpcbind \
                shared-mime-info \
                ssh \
                strace \
                traceroute \
                triggerhappy \
                usb-modeswitch \
                usb-modeswitch-data \
                v4l-utils \
                vim-common \
                vim-tiny \
                wireless-tools \
                wpasupplicant \
                xauth \
                xdg-user-dirs \
                xxd \
                zlib1g-dev:armhf \
                ethtool \
                geoip-database \
                libalgorithm-diff-perl \
                parted \
                pi-bluetooth \
                psmisc \
                freetype2-doc \
                publicsuffix \
                python-rpi.gpio \
                python3-pkg-resources \
                python3-requests \
                python3-six \
                python3-urllib3 \
                rng-tools \
                rsync \
                rsyslog \
                ssh-import-id \
                gdbm-l10n \
                javascript-common \
                multiarch-support \ 
                tasksel \
                libraspberrypi-bin \
                libraspberrypi-dev \
                libraspberrypi-doc \
                libsigc++-1.2-dev \
                raspberrypi-kernel \
                raspi-copies-and-fills \
 && mkdir /etc/firmware \
 && curl -o /etc/firmware/BCM43430A1.hcd -L https://github.com/OpenELEC/misc-firmware/raw/master/firmware/brcm/BCM43430A1.hcd \
 && wget https://raw.githubusercontent.com/raspberrypi/firmware/1.20180417/opt/vc/bin/vcmailbox -O /opt/vc/bin/vcmailbox \
 && apt-get remove git \
 && apt-get autoremove \
 && rm -rf /tmp/* \
 && rm -rf /var/lib/apt/lists/*

#copy files
COPY "./init.d/*" /etc/init.d/

#set the entrypoint
ENTRYPOINT ["/etc/init.d/entrypoint.sh"]

#SSH port
EXPOSE 22

#set STOPSGINAL
STOPSIGNAL SIGTERM

#disable cross compiling (comment out next line if built on Raspberry Pi) 
RUN [ "cross-build-end" ]
