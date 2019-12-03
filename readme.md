How to use docker


make the private registry allow http traffic

[http://stackoverflow.com/questions/38695515/can-not-pull-push-images-after-update-docker-to-1-12], two steps in total to solve this issue:

Create or modify /etc/docker/daemon.json
{ "insecure-registries":["myregistry.example.com:5000"] }
Restart docker daemon
sudo service docker restart


List all images
GET /v2/_catalog

List image tags
GET /v2/<name>/tags/list
