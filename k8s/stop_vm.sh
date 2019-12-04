#!/bin/bash

vboxmanage controlvm "kube master" poweroff soft
vboxmanage controlvm "kube node1" poweroff soft
vboxmanage controlvm "kube node2" poweroff soft
