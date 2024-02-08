#!/bin/bash
echo "Add HELLO to cynagora db"

cynagora-admin set '' 'HELLO' '' '*' yes

# If user "root" uses script in debug mode and so create socket in /tmp/api,
# user "rp-owner" must be able to rw the socket
mkdir -p /tmp/api
chgrp users /tmp/api
chmod g+s /tmp/api
#change de umask for root session
sed -i -E "s/    umask 022/    umask 011/g" /etc/profile
