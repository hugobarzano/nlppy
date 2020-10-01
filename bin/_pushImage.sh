
#!/usr/bin/env bash
docker build . --file Dockerfile --tag image
echo "$2" | docker login docker.pkg.github.com -u $1 --password-stdin
REPO=$(basename `git rev-parse --show-toplevel`)
echo REPO=$REPO
IMAGE_NAME=$(echo "$REPO" | sed -e 's/\//./')
IMAGE_ID="docker.pkg.github.com/$1/$REPO/$1.$IMAGE_NAME"
git fetch

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | 
    grep '"tag_name":' |                                            
    sed -E 's/.*"([^"]+)".*/\1/'                                    
}

CURRENT_VERSION=`get_latest_release $1/$REPO`
VERSION_MINOR=`echo $CURRENT_VERSION | awk -F. '{$NF+=1; OFS="."; print $3}'`
VERSION_MID=`echo $CURRENT_VERSION | awk -F. '{print $2}'`
VERSION_MAYOR=`echo $CURRENT_VERSION | awk -F. '{print $1}'`
[ -z "$VERSION_MINOR" ] && VERSION_MINOR="0"
[ -z "$VERSION_MID" ] && VERSION_MID="0"
[ -z "$VERSION_MAYOR" ] && VERSION_MAYOR="0"
VERSION="$VERSION_MAYOR.$VERSION_MID.$VERSION_MINOR"
echo VERSION=$VERSION

generate_post_data()
{
cat <<EOF
{
"tag_name": "$VERSION",
"target_commitish": "",
"name": "$VERSION",
"body": "Release to deploy",
"draft": false,
"prerelease": false
}
EOF
}
curl --data "$(generate_post_data)" "https://api.github.com/repos/$1/$REPO/releases?access_token=$2"
echo IMAGE_ID:VERSION=$IMAGE_ID:$VERSION
docker tag image "$IMAGE_ID:$VERSION"
docker push $IMAGE_ID:$VERSION
