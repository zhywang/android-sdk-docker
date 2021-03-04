#!/bin/sh
set -e
ANDROID_SDK_VERSION="6858069"
ANDROID_VERSION="29"
ANDROID_BUILD_TOOLS_VERSION="29.0.3"
GRADLE_VERSION="6.8.3"
NAME="zhywang/android-sdk"
TAG="$ANDROID_SDK_VERSION-$ANDROID_VERSION-$ANDROID_BUILD_TOOLS_VERSION"

#prepare android-sdk-linux
mkdir android-sdk-linux
wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip
unzip -qq commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip
rm -rf commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip
mv cmdline-tools/* android-sdk-linux/
yes | android-sdk-linux/bin/sdkmanager --sdk_root=./android-sdk-linux "platform-tools" "build-tools;$ANDROID_BUILD_TOOLS_VERSION" "platforms;android-$ANDROID_VERSION"

wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
unzip -qq gradle-${GRADLE_VERSION}-bin.zip
rm -rf gradle-${GRADLE_VERSION}-bin.zip
mv gradle-${GRADLE_VERSION} gradle
mkdir -p gradle/init.d
cp init.gradle gradle/init.d/init.gradle

wget -q https://github.com/GoogleContainerTools/jib/releases/download/v0.2.0-cli/jib-jre-0.2.0.zip
unzip -qq jib-jre-0.2.0.zip
rm -rf jib-jre-0.2.0.zip
JIB=jib-0.2.0/bin/jib
$JIB build --username "$user" --password "$password" -b jib.yaml -t registry.hub.docker.com/$NAME:$TAG
