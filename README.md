## Raspbian

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![](https://images.microbadger.com/badges/commit/hilschernetpi/netpi-raspbian.svg)](https://microbadger.com/images/hilschernetpi//netpi-raspbian "Raspbian")
[![Docker Registry](https://img.shields.io/docker/pulls/hilschernetpi/netpi-raspbian.svg)](https://registry.hub.docker.com/r/hilschernetpi/netpi-raspbian/)&nbsp;
[![Image last updated](https://img.shields.io/badge/dynamic/json.svg?url=https://api.microbadger.com/v1/images/hilschernetpi/netpi-raspbian&label=Image%20last%20updated&query=$.LastUpdated&colorB=007ec6)](http://microbadger.com/images/hilschernetpi/netpi-raspbian "Image last updated")&nbsp;

Made for Raspberry Pi 3B architecture based devices and compatibles

### Container features 

The image provided hereunder deploys a Debian based container with SSH server, pre-compiled software/packages found installed on Raspbian OS (inclusive userland tools) and a default user which is `pi`.

Base of this image builds [debian](https://www.balena.io/docs/reference/base-images/base-images/) with enabled [SSH](https://en.wikipedia.org/wiki/Secure_Shell), installed [userland](https://github.com/raspberrypi/userland) tools, created user 'pi' and preinstalled packages of a Raspbian lite operating system (headless).

### Container hosts

The container has been successfully tested on the following hosts

* netPI, model RTE 3, product name NIOT-E-NPI3-51-EN-RE
* netPI, model CORE 3, product name NIOT-E-NPI3-EN
* netFIELD Connect, product name NIOT-E-TPI51-EN-RE/NFLD
* Raspberry Pi, model 3B
* Raspberry Pi, model 4B (arm32v7,arm64v8)

netPI devices specifically feature a restricted Docker protecting the Docker host system software's integrity by maximum. The restrictions are

* privileged mode is not automatically adding all host devices `/dev/` to a container
* volume bind mounts to rootfs is not supported
* the devices `/dev`,`/dev/mem`,`/dev/sd*`,`/dev/dm*`,`/dev/mapper`,`/dev/mmcblk*` cannot be added to a container

### Container setup

#### Environment variable (optional)

The container binds the SSH server port to `22` by default.

For an alternative port use the variable **SSHPORT** with the desired port number as value.

#### Network mode

The container supports the bridged or host network mode. More details at [Container networking](https://docs.docker.com/v17.09/engine/userguide/networking/).

##### Bridged

Any unused Docker host port needs to be mapped to the default container port `22` or the one set by **SSHPORT** to expose the container SSH server to the Docker host. 

Remark: Container bluetooth functionality is supported in host network mode only.

##### Host

Port mapping is unnecessary since all the used container ports (like `22` or **SSHPORT**) are exposed to the host automatically.

Remark: Host network mode is mandatory for using container bluetooth functions.

#### Hostname (optional)

For an equal default Raspbian OS hostname set the container hostname to `raspberrypi`.

#### Privileged mode (optional)

The privileged mode lifts the standard Docker enforced container limitations: applications inside a container are getting (almost) all capabilities as if running on the host directly.

Enabling the privileged mode is optional but mandatory for the following container functions:

* bluetooth
* userland tools

#### Host devices (optional)

For bluetooth functionality the `/dev/ttyAMA0` Docker host device needs to be added to the container. In conjunction the `/dev/vcio` Docker host device needs be added to the container as well to allow bluetooth controller resets. 

For using userland tools like [vcmailbox](https://github.com/raspberrypi/userland/blob/master/host_applications/linux/apps/vcmailbox/vcmailbox.c) the `/dev/vcio` and `/dev/vchiq` and `/dev/vc-mem` Docker host devices need to be added to the container.

### Container deployment

Pulling the image may take 10 minutes.

#### netPI example

STEP 1. Open netPI's web UI in your browser (https).

STEP 2. Click the Docker tile to open the [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 3. Enter the following parameters under *Containers > + Add Container*

Parameter | Value | Remark
:---------|:------ |:------
*Image* | **hilschernetpi/netpi-raspbian** | a :tag may be added as well
*Network > Network* | **bridge** or **host** | use either or
*Network > Hostname* | **raspberrypi** | optional
*Restart policy* | **always**
*Runtime > Env* | *name* **SSHPORT** -> *value* **any number value** | optional for different SSH port
*Port mapping* | *host* **unused port** -> *container* **22** / **SSHPORT** | in bridged mode only
*Runtime > Devices > +add device* | *Host path* **/dev/ttyAMA0** -> *Container path* **/dev/ttyAMA0** | optional for bluetooth
*Runtime > Devices > +add device* | *Host path* **/dev/vcio** -> *Container path* **/dev/vcio** | optional for bluetooth, userland tools
*Runtime > Devices > +add device* | *Host path* **/dev/vchiq** -> *Container path* **/dev/vchiq** | optional for userland tools
*Runtime > Devices > +add device* | *Host path* **/dev/vc-mem** -> *Container path* **/dev/vc-mem** | optional for userland tools
*Runtime > Privileged mode* | **On** | optional for bluetooth, userland tools

STEP 4. Press the button *Actions > Start/Deploy container*

#### Docker command line example

`docker run -d --privileged --network=host --restart=always -e SSHPORT=22 --device=/dev/ttyAMA0:/dev/ttyAMA0 --device=/dev/vcio:/dev/vcio --device=/dev/vchiq:/dev/vchiq --device=/dev/vc-mem:/dev/vc-mem -p 22:22/tcp hilschernetpi/netpi-raspbian`

#### Docker compose example

A `docker-compose.yml` file could look like this

    version: "2"

    services:
     nodered:
       image: hilschernetpi/netpi-raspbian
       restart: always
       privileged: true
       network_mode: host
       ports:
         - 22:22
       devices:
         - "/dev/ttyAMA0:/dev/ttyAMA0"
         - "/dev/vcio:/dev/vcio"
         - "/dev/vchiq:/dev/vchiq"
         - "/dev/vc-mem:/dev/vc-mem"
       environment:
         - SSHPORT=22

### Container access

The container starts the SSH server automatically when deployed. 

For an SSH terminal session use an SSH client such as [putty](http://www.putty.org/) with the Docker host IP address (@port number `22` or **SSHPORT** or bridge mode mapped one).

Use the credentials `pi` as user and `raspberry` as password when asked and you are logged in as non-root user `pi`.

Continue to use [Linux commands](https://www.raspberrypi.org/documentation/linux/usage/commands.md) in the terminal as usual.

### Container on Youtube

[![Tutorial](https://img.youtube.com/vi/A-asfhl7b0c/0.jpg)](https://youtu.be/A-asfhl7b0c)

### License

Copyright (c) Hilscher Gesellschaft fuer Systemautomation mbH. All rights reserved.
Licensed under the LISENSE.txt file information stored in the project's source code repository.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[![N|Solid](http://www.hilscher.com/fileadmin/templates/doctima_2013/resources/Images/logo_hilscher.png)](http://www.hilscher.com)  Hilscher Gesellschaft fuer Systemautomation mbH  www.hilscher.com
