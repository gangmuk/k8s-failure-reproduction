#!/bin/bash

kubectl label --overwrite nodes kind-worker lifecycle-
kubectl label --overwrite nodes kind-worker2 lifecycle-
kubectl label --overwrite nodes kind-worker3 lifecycle-
