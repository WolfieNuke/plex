#!/bin/bash

# Check to see what version of Plex is installed vs what is being requested. If requested version is different
# install that one 

INSTALLED=`dpkg-query -W -f='${Version}' plexmediaserver`

if [ -z "$VERSION" ]; then
    PLEX_URL=$(curl -sL http://plex.baconopolis.net/latest.php)
else
    PLEX_URL=$(curl -sL http://plex.baconopolis.net/version.php?version=${VERSION})
fi
PLEX_VERSION=$(echo $PLEX_URL | awk -F_ '{print $2}')

if [ -z "$PLEX_VERSION" ]; then
    echo "Unable to get plex version"
    exit 0
fi
if [ "$PLEX_VERSION" = "$INSTALLED" ]; then
    echo "Version not changed - $PLEX_VERSION"
else
    echo "Updating to $PLEX_VERSION from $INSTALLED"
    mv /etc/default/plexmediaserver /tmp/
    apt-get remove --purge -y plexmediaserver
    wget -P /tmp "${PLEX_URL}"
    gdebi -n /tmp/plexmediaserver_${PLEX_VERSION}_amd64.deb
    mv /tmp/plexmediaserver /etc/default/
fi
