#!/usr/bin/env bash

mvn clean package
mkdir -p oc_deploy/impl/target
cp impl/target/build-reproducer-impl-1.0-SNAPSHOT.jar oc_deploy/impl/target/
oc start-build openshift-s2i-build-reproducer --from-dir=oc_deploy --follow --wait
