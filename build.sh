#!/bin/sh
set -e
ANDROID_SDK_VERSION="3859397"
ANDROID_VERSION="25"
ANDROID_BUILD_TOOLS_VERSION="25.0.3"
NAME="zhywang/android-sdk"
TAG="$ANDROID_SDK_VERSION-$ANDROID_VERSION-$ANDROID_BUILD_TOOLS_VERSION"
sed -e "s/EMAIL/$email/;s/AUTH/$auth/" templ > config.json
docker build --build-arg ANDROID_SDK_VERSION=$ANDROID_SDK_VERSION --build-arg ANDROID_VERSION=$ANDROID_VERSION --build-arg ANDROID_BUILD_TOOLS_VERSION=$ANDROID_BUILD_TOOLS_VERSION -t "$NAME" .
docker tag $NAME $NAME:$TAG
docker --config=. push "$NAME:$TAG"
