#!/bin/bash
VBoxManage list vms

VBoxHeadless -s "kube master" & jobs
VBoxHeadless -s "kube node1" & jobs
VBoxHeadless -s "kube node2" & jobs
