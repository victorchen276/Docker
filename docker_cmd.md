# Useful Docker Command
1: delete all stopped docker containers
```
docker rm -v $(docker ps -a -q -f status=exited)
```

2: Running an interactive shell
```
docker run -i -t ubuntu /bin/bash
```
