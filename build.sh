#!/bin/sh
set -x
ANDROID_SDK_VERSION="6858069"
ANDROID_VERSION="29"
ANDROID_BUILD_TOOLS_VERSION="29.0.3"
GRADLE_VERSION="6.8.3"
NAME="zhywang/android-sdk"
TAG="$ANDROID_SDK_VERSION-$ANDROID_VERSION-$ANDROID_BUILD_TOOLS_VERSION"

wget -qO- https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip | jar x

mkdir android-sdk-linux
yes | cmdline-tools/bin/sdkmanager --sdk_root=./android-sdk-linux --licenses > /dev/null 2>&1
yes | cmdline-tools/bin/sdkmanager --sdk_root=./android-sdk-linux "platform-tools"
yes | cmdline-tools/bin/sdkmanager --sdk_root=./android-sdk-linux "build-tools;$ANDROID_BUILD_TOOLS_VERSION"
yes | cmdline-tools/bin/sdkmanager --sdk_root=./android-sdk-linux "platforms;android-$ANDROID_VERSION"
yes | cmdline-tools/bin/sdkmanager --sdk_root=./android-sdk-linux "cmdline-tools;latest"

wget -qO- https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip | jar x
mv gradle-${GRADLE_VERSION} gradle
mkdir -p gradle/init.d
cp init.gradle gradle/init.d/init.gradle

wget -qO- https://github.com/GoogleContainerTools/jib/releases/download/v0.2.0-cli/jib-jre-0.2.0.zip | jar x
JIB=jib-0.2.0/bin/jib
chmod +x $JIB
$JIB build --username "$user" --password "$password" -b jib.yaml -t registry.hub.docker.com/$NAME:$TAG