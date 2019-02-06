#use armv7hf compatible base image
FROM balenalib/armv7hf-debian:stretch

#dynamic build arguments coming from the /hook/build file
ARG BUILD_DATE
ARG VCS_REF

#metadata labels
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/HilscherAutomation/netPI-raspbian" \
      org.label-schema.vcs-ref=$VCS_REF

#enable building ARM container on x86 machinery on the web (comment out next line if built on Raspberry)
RUN [ "cross-build-start" ]

#version
ENV HILSCHERNETPI_RASPBIAN_VERSION 1.0.2

#labeling
LABEL maintainer="netpi@hilscher.com" \
      version=$HILSCHERNETPI_RASPBIAN_VERSION \
      description="Raspbian"

#environment variables
ENV USER=pi
ENV PASSWD=raspberry

#copy files
COPY "./init.d/*" /etc/init.d/

RUN apt-get update \
    && apt-get install wget \
    && wget https://archive.raspbian.org/raspbian.public.key -O - | apt-key add - \
    && echo 'deb http://raspbian.raspberrypi.org/raspbian/ stretch main contrib non-free rpi' | tee -a /etc/apt/sources.list \
    && wget -O - http://archive.raspberrypi.org/debian/raspberrypi.gpg.key | sudo apt-key add - \
    && echo 'deb http://archive.raspberrypi.org/debian/ stretch main ui' | tee -a /etc/apt/sources.list.d/raspi.list \
    && apt-get update  \
    && apt-get install -y openssh-server \
    && mkdir /var/run/sshd \
    # && sed -i -e 's;#Port 22;Port 23;' /etc/ssh/sshd_config \ #Comment in if SSH port other than 22 is needed (22->23)
    && sed -i 's@#force_color_prompt=yes@force_color_prompt=yes@g' -i /etc/skel/.bashrc \
    && useradd --create-home --shell /bin/bash pi \
    && echo $USER:$PASSWD | chpasswd \
    && adduser $USER sudo \
    && echo $USER " ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/010_pi-nopasswd \
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
                i2c-tools \
                usbutils \
                build-essential \
                git \
                python \
                aptitude \
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
                blends-tasks \
                bluez \
                bsdmainutils \
                cifs-utils \
                console-setup \
                console-setup-linux \
                dh-python \
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
                initramfs-tools \
                initramfs-tools-core \
                iso-codes \
                keyutils \
                klibc-utils \   
                locales \
                logrotate \
                lsb-release \
                lua5.1 \
                luajit \
                makedev \
                man-db  \
                manpages \
                manpages-dev \
                mountall \
                ncdu \
                ncurses-term \
                netcat-openbsd \
                netcat-traditional \
                nfs-common \
                openresolv \
                paxctld \
                pkg-config \
                plymouth \
                policykit-1 \
                rename \
                rfkill \
                rpcbind \
                sgml-base \
                shared-mime-info \
                ssh \
                strace \
                tcpd \
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
                xml-core  \
                xxd \
                zlib1g-dev:armhf \
                autotools-dev \
                autoconf \
                automake \ 
                cmake \
                bison \
                flex \
                libtool \
                python-dev \
                python-pip \
    && git clone --depth 1 https://github.com/raspberrypi/firmware /tmp/firmware \
    && mv /tmp/firmware/hardfp/opt/vc /opt \
    && echo "/opt/vc/lib" >/etc/ld.so.conf.d/00-vmcs.conf \
    && /sbin/ldconfig \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

#set the entrypoint
ENTRYPOINT ["/etc/init.d/entrypoint.sh"]

#SSH port
EXPOSE 22

#set STOPSGINAL
STOPSIGNAL SIGTERM

#stop processing ARM emulation (comment out next line if built on Raspberry)
RUN [ "cross-build-end" ]
