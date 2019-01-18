#!/usr/bin/env bash

oc delete bc,is -l build=openshift-s2i-build-reproducer
