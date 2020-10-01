
#!/usr/bin/env bash

echo "$2" | docker login docker.pkg.github.com -u $1 --password-stdin
REPO=$(basename `git rev-parse --show-toplevel`)
IMAGE_NAME=$(echo "$REPO" | sed -e 's/\//./')
IMAGE_ID="docker.pkg.github.com/$1/$REPO/$1.$IMAGE_NAME"
VERSION="latest"
echo IMAGE_ID:VERSION=$IMAGE_ID:$VERSION
docker pull $IMAGE_ID:$VERSION
