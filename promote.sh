#!/bin/bash

IFS='_' read -r -a fullver <<< $1
export RPM_RELEASE=${fullver[1]}
export RPM_VERSION=${fullver[0]}
export YUM_PATH=stable

RPM_NAME=etcd-$RPM_VERSION-$RPM_RELEASE.el7.x86_64.rpm
RPM_URL=https://dl.bintray.com/jumperfly/yum/etcd/latest/$RPM_NAME

echo "########## Starting promote for version $RPM_VERSION-$RPM_RELEASE ##########"
mkdir -p build/RPMS/x86_64
cd build/RPMS/x86_64
echo Downloading $RPM_URL
curl -fLO $RPM_URL || exit 1
echo Downloaded $(md5sum $RPM_NAME)
cd ../../..
envsubst < bintray-descriptor.json > build/bintray-descriptor.json
