#!/bin/bash

export RPM_RELEASE=$1
export RPM_VERSION=3.2.24
export YUM_PATH=latest

echo "########## Starting build for version $RPM_VERSION-$RPM_RELEASE ##########"

echo "########## Clean and prepare build directory ##########"
if [ -e build ]; then
  sudo rm -rf build
fi
mkdir -p build/rpm/usr/share/licenses/etcd-$RPM_VERSION
mkdir -p build/rpm/var/lib/etcd
mkdir -p build/rpm/usr/bin

echo "########## Download etcd and extract binaries ##########"
curl --output - -L https://github.com/etcd-io/etcd/releases/download/v$RPM_VERSION/etcd-v$RPM_VERSION-linux-amd64.tar.gz | tar xz -C build
cp build/etcd-v$RPM_VERSION-linux-amd64/{etcd,etcdctl} build/rpm/usr/bin

echo "########## Prepare rpm ##########"
cp -r src/* build/rpm
cp LICENSE build/rpm/usr/share/licenses/etcd-$RPM_VERSION

echo "########## Build rpm ##########"
docker run --rm -v $(pwd):/build jumperfly/rpmbuild:v4.11.3_1 \
  rpmbuild -bb --buildroot /build/build/rpm \
  --define "_topdir /build/build" \
  --define "_release $RPM_RELEASE" \
  --define "_version $RPM_VERSION" \
  /build/etcd.spec

echo "########## Generate deployment properties ##########"
envsubst < bintray-descriptor.json > build/bintray-descriptor.json
