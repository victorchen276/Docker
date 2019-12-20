#!/bin/bash

vboxmanage controlvm "kube master 1" poweroff soft
vboxmanage controlvm "kube node 1" poweroff soft
vboxmanage controlvm "kube node 2" poweroff soft
