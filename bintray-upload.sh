#!/bin/bash
set -e

curl -T build/RPMS/x86_64/*.rpm \
  -ujumperfly:$(gcloud secrets versions access latest --secret=bintray) \
  https://api.bintray.com/content/jumperfly/yum/etcd/${ETCD_VERSION}/etcd/latest/$(basename build/RPMS/x86_64/*.rpm)
curl -X POST \
  -ujumperfly:$(gcloud secrets versions access latest --secret=bintray) \
  https://api.bintray.com/content/jumperfly/yum/etcd/${ETCD_VERSION}/publish
