#!/bin/bash +e
# catch signals as PID 1 in a container

# SIGNAL-handler
term_handler() {

  echo "stopping bluetooth daemon ..."
  if [ $pidbt -ne 0 ]; then
        kill -SIGTERM "$pidbt"
        wait "$pidbt"
        echo "bring hci0 down ..."
        hciconfig hci0 down
  fi

  echo "terminating dbus ..."
  /etc/init.d/dbus stop

  echo "terminating ssh ..."
  sudo /etc/init.d/ssh stop

  exit 143; # 128 + 15 -- SIGTERM
}

# on callback, stop all started processes in term_handler
trap 'kill ${!}; term_handler' SIGINT SIGKILL SIGTERM SIGQUIT SIGTSTP SIGSTOP SIGHUP

echo "starting SSH server ..."
if [ "SSHPORT" ]; then
  #there is an alternative SSH port configured
  echo "the container binds the SSH server port to the configured port $SSHPORT"
  sed -i -e "s;#Port 22;Port $SSHPORT;" /etc/ssh/sshd_config
else
  echo "the container binds the SSH server port to the default port 22"
fi

echo "note: in bridged network mode the container SSH port maps to the Docker host according your port mapping setup" 

sudo /etc/init.d/ssh start

# start dbus deamon
echo "starting dbus ..."
/etc/init.d/dbus start

pidbt=0

if [[ -n `grep "docker0" /proc/net/dev` ]]; then
  #container is running in host mode
  ip link add dummy0 type dummy >/dev/null 2>&1
  if [[ -n `grep "dummy0" /proc/net/dev` ]]; then
    ip link delete dummy0 >/dev/null 2>&1
    #container running in privileged mode
    if [[ -e "/dev/ttyAMA0" ]]; then 
      #bluetooth can be supported
      echo "info: detected hardware setup allows using bluetooth functions in the container"
      if [[ -e "/dev/vcio" ]]; then
        #reset BCM chip possible
        /opt/vc/bin/vcmailbox 0x38041 8 8 128 0 >/dev/null
        sleep 1
        /opt/vc/bin/vcmailbox 0x38041 8 8 128 1 >/dev/null
        sleep 1
      fi

      #load firmware to BCM chip and attach to hci0
      hciattach /dev/ttyAMA0 bcm43xx 115200 noflow

      #create hci0 device
      hciconfig hci0 up

      #start bluetooth daemon
      bluetoothd -d &
      pidbt="$!"
    fi
  fi
fi


# wait forever not to exit the container
while true
do
  tail -f /dev/null & wait ${!}
done

exit 0
