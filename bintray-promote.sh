#!/bin/bash
set -e

ETCD_VERSION=$(grep 'ETCD_VERSION:' cloudbuild.yaml | sed 's/.*_ETCD_VERSION: //' | sed 's/"//g')
git fetch --unshallow --no-tags
BUILD_NUMBER=$(git rev-list --count HEAD)
EXPECTED_TAG_NAME="v${ETCD_VERSION}_${BUILD_NUMBER}"
RPM_FILENAME="etcd-${ETCD_VERSION}-${BUILD_NUMBER}.${SHORT_SHA}.el7.x86_64.rpm"
BINTRAY_APIKEY=$(gcloud secrets versions access latest --secret=bintray)

if [[ "$TAG_NAME" != "$EXPECTED_TAG_NAME" ]]; then
  echo "ERROR: Unexpected tag name for commit $SHORT_SHA, expected tag: $EXPECTED_TAG_NAME but found tag $TAG_NAME"
  exit 1
fi

curl -O https://dl.bintray.com/jumperfly/yum/etcd/latest/$RPM_FILENAME
curl -T $RPM_FILENAME \
  -ujumperfly:$BINTRAY_APIKEY \
  https://api.bintray.com/content/jumperfly/yum/etcd/${ETCD_VERSION}/etcd/stable/$RPM_FILENAME
curl -X POST \
  -ujumperfly:$BINTRAY_APIKEY \
  https://api.bintray.com/content/jumperfly/yum/etcd/${ETCD_VERSION}/publish
