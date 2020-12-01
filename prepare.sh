#!/bin/bash

if [ -e build ]; then
  sudo rm -rf build
fi
mkdir -p build/rpm/usr/share/licenses/etcd-$RPM_VERSION
mkdir -p build/rpm/var/lib/etcd
mkdir -p build/rpm/usr/bin

curl --output - -L https://github.com/etcd-io/etcd/releases/download/v$RPM_VERSION/etcd-v$RPM_VERSION-linux-amd64.tar.gz | tar xz -C build
cp build/etcd-v$RPM_VERSION-linux-amd64/{etcd,etcdctl} build/rpm/usr/bin

cp -r src/* build/rpm
cp LICENSE build/rpm/usr/share/licenses/etcd-$RPM_VERSION
