#!/bin/bash

kubectl taint node kind-worker key1=value1:NoExecute
