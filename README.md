## Raspbian

[![](https://images.microbadger.com/badges/image/hilschernetpi/netpi-raspbian.svg)](https://microbadger.com/images/hilschernetpi/netpi-raspbian "Raspbian")
[![](https://images.microbadger.com/badges/commit/hilschernetpi/netpi-raspbian.svg)](https://microbadger.com/images/hilschernetpi//netpi-raspbian "Raspbian")
[![Docker Registry](https://img.shields.io/docker/pulls/hilschernetpi/netpi-raspbian.svg)](https://registry.hub.docker.com/u/hilschernetpi/netpi-raspbian/)&nbsp;
[![Image last updated](https://img.shields.io/badge/dynamic/json.svg?url=https://api.microbadger.com/v1/images/hilschernetpi/netpi-raspbian&label=Image%20last%20updated&query=$.LastUpdated&colorB=007ec6)](http://microbadger.com/images/hilschernetpi/netpi-raspbian "Image last updated")&nbsp;

Made for [netPI](https://www.netiot.com/netpi/), the Raspberry Pi 3B Architecture based industrial suited Open Edge Connectivity Ecosystem

### Secured netPI Docker

netPI features a restricted Docker protecting the system software's integrity by maximum. The restrictions are 

* privileged mode is not automatically adding all host devices `/dev/` to a container
* volume bind mounts to rootfs is not supported
* the devices `/dev`,`/dev/mem`,`/dev/sd*`,`/dev/dm*`,`/dev/mapper`,`/dev/mmcblk*` cannot be added to a container

### Container features 

The image provided hereunder deploys a container with Debian, SSH server, Raspberry Pi userland tool and created user pi.

Base of this image builds [debian](https://www.balena.io/docs/reference/base-images/base-images/) with enabled [SSH](https://en.wikipedia.org/wiki/Secure_Shell), created user 'pi' and preinstalled packages of a headless Raspbian lite.

### Container setup

#### Port mapping

For a SSH login to the container any unused netPI host port needs to be added to the container port `22` (SSH).

#### Hostname (optional)

For an equal standard Raspberry Pi condition set the container hostname to `raspberrypi`.

#### Privileged mode (optional)

The privileged mode option needs to be activated to lift the standard Docker enforced container limitations. With this setting the container and the applications inside are the getting (almost) all capabilities as if running on the Host directly. 

netPI's secure reference software architecture prohibits root access to the Host system always. Even if priviledged mode is activated the intrinsic security of the Host Linux Kernel can not be compromised.

#### Host device (optional)

The container includes the [userland](https://github.com/raspberrypi/userland) tools installed with original Raspbian OS too. To grant access of tools like [vcmailbox](https://github.com/raspberrypi/userland/blob/master/host_applications/linux/apps/vcmailbox/vcmailbox.c) the `/dev/vcio` and `/dev/vchiq` and `/dev/vc-mem` host devices need to be exposed to the container. (Prerequisite is running the container in privileged mode).

### Container deployment

STEP 1. Open netPI's website in your browser (https).

STEP 2. Click the Docker tile to open the [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 3. Enter the following parameters under *Containers > + Add Container*

Parameter | Value | Remark
:---------|:------ |:------
*Image* | **hilschernetpi/netpi-raspbian**
*Network > Hostname* | **raspberrypi** | optional
*Port mapping* | *host* **22** -> *container* **22** | *host*=any unused
*Restart policy* | **always**
*Runtime > Devices > +add device* | *Host path* **/dev/vcio** -> *Container path* **/dev/vcio** | optional
*Runtime > Devices > +add device* | *Host path* **/dev/vchiq** -> *Container path* **/dev/vchiq** | optional
*Runtime > Devices > +add device* | *Host path* **/dev/vc-mem** -> *Container path* **/dev/vc-mem** | optional
*Runtime > Privileged mode* | **On** | optional

STEP 4. Press the button *Actions > Start/Deploy container*

Pulling the image may take a while (5-10mins). Sometimes it may take too long and a time out is indicated. In this case repeat STEP 4.

### Container access

The container automatically starts the SSH server. For a SSH session use a SSH client such as [putty](http://www.putty.org/) with the netPI IP address (@mapped SSH host port number).

Use the credentials `pi` as user and `raspberry` as password when asked and you are logged in as non-root user `pi`.

Continue to use [Linux commands](https://www.raspberrypi.org/documentation/linux/usage/commands.md) in the terminal as usual.

### Container on Youtube

[![Tutorial](https://img.youtube.com/vi/A-asfhl7b0c/0.jpg)](https://youtu.be/A-asfhl7b0c)

### Container tips & tricks

For additional help or information visit the Hilscher Forum at https://forum.hilscher.com/

### Contaner automated build

The project complies with the scripting based [Dockerfile](https://docs.docker.com/engine/reference/builder/) method to build the image output file. Using this method is a precondition for an [automated](https://docs.docker.com/docker-hub/builds/) web based build process on DockerHub platform.

DockerHub web platform is x86 CPU based, but an ARM CPU coded output file is needed for Raspberry Pi systems. This is why the Dockerfile includes the [balena.io](https://balena.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/) steps.

### License

View the license information for the software in the project. As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[![N|Solid](http://www.hilscher.com/fileadmin/templates/doctima_2013/resources/Images/logo_hilscher.png)](http://www.hilscher.com)  Hilscher Gesellschaft fuer Systemautomation mbH  www.hilscher.com
