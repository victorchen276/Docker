#!/bin/bash

docker run -d --name flaskapp --restart=always -p 8091:80 docker-flask:0.1
