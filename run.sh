#! /bin/bash

if [ "$(uname)" != "Darwin" ]; then
    echo $0: script only runs on Mac OS X.
    exit 1
fi

vbm="/Applications/VirtualBox.app/Contents/MacOS/VBoxManage"
vm="boot2docker-vm"

set -eux

docker run -d -p 10000-10035:10000-10035 --name agraph franzinc/agraph

sudo "$vbm" controlvm $vm natpf1 delete "tcp-port10035"
sudo "$vbm" controlvm $vm natpf1 "tcp-port10035,tcp,,10035,,10035"
