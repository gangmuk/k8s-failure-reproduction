#!/bin/bash

kubectl label --overwrite nodes kind-worker node-
kubectl label --overwrite nodes kind-worker2 node-
kubectl label --overwrite nodes kind-worker3 node-
