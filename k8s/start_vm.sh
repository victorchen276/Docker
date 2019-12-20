#!/bin/bash
VBoxManage list vms

VBoxHeadless -s "kube master 1" & jobs
VBoxHeadless -s "kube node 1" & jobs
VBoxHeadless -s "kube node 2" & jobs
