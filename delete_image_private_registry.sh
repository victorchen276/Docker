registry='192.168.1.5:5000'
name='image name'
curl -v -sSL -X DELETE "http://${registry}/v2/${name}/manifests/$(
    curl -sSL -I \
        -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
        "http://${registry}/v2/${name}/manifests/$(
            curl -sSL "http://${registry}/v2/${name}/tags/list" | jq -r '.tags[0]'
        )" \
    | awk '$1 == "Docker-Content-Digest:" { print $2 }' \
    | tr -d $'\r' \
)"
