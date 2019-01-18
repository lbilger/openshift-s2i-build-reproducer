#!/usr/bin/env bash

oc new-build https://github.com/lbilger/openshift-s2i-build-reproducer.git -i java
oc cancel-build bc/openshift-s2i-build-reproducer
oc set env bc/openshift-s2i-build-reproducer ARTIFACT_DIR=impl/target
