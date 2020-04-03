## Raspbian

[![](https://images.microbadger.com/badges/commit/hilschernetpi/netpi-raspbian.svg)](https://microbadger.com/images/hilschernetpi//netpi-raspbian "Raspbian")
[![Docker Registry](https://img.shields.io/docker/pulls/hilschernetpi/netpi-raspbian.svg)](https://registry.hub.docker.com/r/hilschernetpi/netpi-raspbian/)&nbsp;
[![Image last updated](https://img.shields.io/badge/dynamic/json.svg?url=https://api.microbadger.com/v1/images/hilschernetpi/netpi-raspbian&label=Image%20last%20updated&query=$.LastUpdated&colorB=007ec6)](http://microbadger.com/images/hilschernetpi/netpi-raspbian "Image last updated")&nbsp;

Made for [netPI](https://www.netiot.com/netpi/), the Raspberry Pi 3B Architecture based industrial suited Open Edge Connectivity Ecosystem

### Secured netPI Docker

netPI features a restricted Docker protecting the system software's integrity by maximum. The restrictions are 

* privileged mode is not automatically adding all host devices `/dev/` to a container
* volume bind mounts to rootfs is not supported
* the devices `/dev`,`/dev/mem`,`/dev/sd*`,`/dev/dm*`,`/dev/mapper`,`/dev/mmcblk*` cannot be added to a container

### Container features 

The image provided hereunder deploys a container with Debian, SSH server, pre-compiled software/packages typically found installed on Raspbian OS (inclusive userland tools) and default user pi.

Base of this image builds [debian](https://www.balena.io/docs/reference/base-images/base-images/) with enabled [SSH](https://en.wikipedia.org/wiki/Secure_Shell), installed [userland](https://github.com/raspberrypi/userland) tools, created user 'pi' and preinstalled packages of a Raspbian lite operating system (headless).

### Container setup

#### Network mode

The container supports bridged or host network mode. More details at [Container networking](https://docs.docker.com/v17.09/engine/userguide/networking/).

##### Bridged

Any unused netPI host port needs to be mapped to the container port `22` to expose the container SSH server to the host. 

Remark: Container bluetooth communications are supported in host network mode only.

##### Host

Port mapping is unnecessary since all the used container ports (like 22) are exposed to the host automatically.

Remark: Host network mode is mandatory for container bluetooth communications.

#### Hostname (optional)

For an equal default Raspbian OS hostname set the container hostname to `raspberrypi`.

#### Privileged mode (optional)

The privileged mode lifts the standard Docker enforced container limitations: applications inside a container are getting (almost) all capabilities as if running on the host directly.

Enabling the privileged mode is optional but mandatory for the following container functions:

* bluetooth communications
* using userland tools

#### Host devices (optional)

For bluetooth communications the `/dev/ttyAMA0` host device needs to be added to the container. In conjunction the `/dev/vcio` host device needs be added to the container too to allow proper bluetooth controller resets. 

For using userland tools like [vcmailbox](https://github.com/raspberrypi/userland/blob/master/host_applications/linux/apps/vcmailbox/vcmailbox.c) the `/dev/vcio` and `/dev/vchiq` and `/dev/vc-mem` host devices need to be added to the container.

### Container deployment

STEP 1. Open netPI's website in your browser (https).

STEP 2. Click the Docker tile to open the [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 3. Enter the following parameters under *Containers > + Add Container*

Parameter | Value | Remark
:---------|:------ |:------
*Image* | **hilschernetpi/netpi-raspbian**
*Network > Network* | **bridge** or **host** | use alternatively
*Network > Hostname* | **raspberrypi** | optional
*Port mapping* | *host* **22** -> *container* **22** | *host*=any unused, bridged mode only
*Restart policy* | **always**
*Runtime > Devices > +add device* | *Host path* **/dev/ttyAMA0** -> *Container path* **/dev/ttyAMA0** | optional for bluetooth
*Runtime > Devices > +add device* | *Host path* **/dev/vcio** -> *Container path* **/dev/vcio** | optional for bluetooth, userland tools
*Runtime > Devices > +add device* | *Host path* **/dev/vchiq** -> *Container path* **/dev/vchiq** | optional for userland tools
*Runtime > Devices > +add device* | *Host path* **/dev/vc-mem** -> *Container path* **/dev/vc-mem** | optional for userland tools
*Runtime > Privileged mode* | **On** | optional for bluetooth, userland tools

STEP 4. Press the button *Actions > Start/Deploy container*

Pulling the image may take a while (5-10mins). Sometimes it may take too long and a time out is indicated. In this case repeat STEP 4.

### Container access

The container automatically starts the SSH server. For a SSH terminal session use a SSH client such as [putty](http://www.putty.org/) with the netPI IP address (@mapped SSH host port number).

Use the credentials `pi` as user and `raspberry` as password when asked and you are logged in as non-root user `pi`.

Continue to use [Linux commands](https://www.raspberrypi.org/documentation/linux/usage/commands.md) in the terminal as usual.

### Container on Youtube

[![Tutorial](https://img.youtube.com/vi/A-asfhl7b0c/0.jpg)](https://youtu.be/A-asfhl7b0c)

### Container tips & tricks

For additional help or information visit the Hilscher Forum at https://forum.hilscher.com/

### License

View the license information for the software in the project. As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[![N|Solid](http://www.hilscher.com/fileadmin/templates/doctima_2013/resources/Images/logo_hilscher.png)](http://www.hilscher.com)  Hilscher Gesellschaft fuer Systemautomation mbH  www.hilscher.com
