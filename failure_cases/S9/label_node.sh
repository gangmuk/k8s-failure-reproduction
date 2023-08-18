#!/bin/bash

kubectl label nodes kind-worker lifecycle=spot
kubectl label nodes kind-worker2 lifecycle=spot
kubectl label nodes kind-worker3 lifecycle=on-demand
