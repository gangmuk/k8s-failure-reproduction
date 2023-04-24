#!/bin/bash

kubectl label nodes kind-worker zone=A
kubectl label nodes kind-worker2 zone=A
kubectl label nodes kind-worker3 zone=B
kubectl label nodes kind-worker node=1
kubectl label nodes kind-worker2 node=2
kubectl label nodes kind-worker3 node=3
