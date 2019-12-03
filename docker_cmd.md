# Useful Docker Command
1: delete all stopped docker containers
```
docker rm -v $(docker ps -a -q -f status=exited)
```
```
docker rm -v $(docker ps -a -q -f status=created)
```

2: Running an interactive shell
```
docker run -i -t ubuntu /bin/bash
```


3: List all images from a private registry

http://192.168.1.5:5000/v2/_catalog

4: List all tags of an image
http://192.168.1.5:5000/v2/image name/tags/list
