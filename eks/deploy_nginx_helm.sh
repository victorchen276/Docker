#!/bin/bash

helm repo update
helm search nginx

helm repo add bitnami https://charts.bitnami.com/bitnami

helm search bitnami/nginx

helm install --name mywebserver bitnami/nginx

kubectl describe deployment mywebserver

kubectl get pods -l app.kubernetes.io/name=nginx

kubectl get service mywebserver-nginx -o wide


#clean up
helm list
# helm delete --purge mywebserver
# kubectl get pods -l app.kubernetes.io/name=nginx
# kubectl get service mywebserver-nginx -o wide