#!/bin/bash

kubectl label --overwrite nodes kind-worker zone-
kubectl label --overwrite nodes kind-worker2 zone-
kubectl label --overwrite nodes kind-worker3 zone-
kubectl label --overwrite nodes kind-worker node-
kubectl label --overwrite nodes kind-worker2 node-
kubectl label --overwrite nodes kind-worker3 node-
