#!/bin/bash
docker run -it --name flaskapp -p 5000:5000 -v $PWD/app:/app docker-flask:0.1 -d debug
