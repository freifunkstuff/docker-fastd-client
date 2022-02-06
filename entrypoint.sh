#!/bin/bash
set -e

# check required env variables
: "${FASTD_MTU:? must be set}"
: "${FASTD_PEER1_REMOTE:? must be set}"
: "${FASTD_PEER1_KEY:? must be set}"

# set some defaults
: "${FASTD_LOG_LEVEL:=info}"

mkdir -p /config/fastd/peers
cat << EOF > /config/fastd/fastd.conf
log level ${FASTD_LOG_LEVEL};
bind any:10061;
mode tap;
interface "mesh-vpn";
method "salsa2012+umac";
method "salsa2012+gmac";
method "null+salsa2012+umac";
method "null";
mtu ${FASTD_MTU};
secret "$( fastd --generate-key 2>/dev/null | grep -e Secret | awk '{ print $2 }' )";
on up "
  ip link set up dev mesh-vpn
  batctl if add mesh-vpn
  ifconfig bat0 up
  $( -z "${IPV6_PREFIX}" || echo "radvd -C /config/radvd.conf" )
";
include peers from "peers";
EOF

# generate peers
i=1
while true; do
  r="FASTD_PEER${i}_REMOTE"
  k="FASTD_PEER${i}_KEY"
  n="FASTD_PEER${i}_NAME"
  if [ -z "${!r}${!k}${!n}" ]; then
    # break after last defined peer
    break;
  fi
  name=${!n:-peer$[i]}
  remote=${!r}
  key=${!k}
  : ${remote:? ${r} must be set}
  : ${key:? ${k} must be set}

cat << EOF > "/config/fastd/peers/${name}"
key "${key}";
remote ${remote};
EOF

  i=$(( i + 1 ))
done

if [ ! -z "${IPV6_PREFIX}" ]; then
cat << EOF > "/config/radvd.conf"
interface bat0
{
    AdvSendAdvert on;
    prefix ${IPV6_PREFIX} {
        AdvOnLink on;
        AdvAutonomous on;		
	};
};
EOF
fi

# create tun device
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

exec fastd --config /config/fastd/fastd.conf
