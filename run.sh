#! /bin/bash

set -eu

function e {
    echo "+ $*"
    "$@"
}

if [ "$(uname)" != "Darwin" ]; then
    echo $0: this script only runs on Mac OS X.
    exit 1
fi

vbm="/Applications/VirtualBox.app/Contents/MacOS/VBoxManage"
# The default name given by docker-machine:
vm="default"

e docker run -d -p 10000-10035:10000-10035 --name agraph \
  --volumes-from agraph-data franzinc/agraph

echo The IP of the container just started: $(docker-machine ip $vm)

if ! e "$vbm" controlvm $vm natpf1 delete "tcp-port10035"; then
    echo delete of NAT rule failed, but maybe it did not exist
fi
e "$vbm" controlvm $vm natpf1 "tcp-port10035,tcp,,10035,,10035"

echo AGWebView URL: http://localhost:10035
