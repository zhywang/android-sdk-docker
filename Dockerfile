FROM ubuntu:16.04

MAINTAINER Wang Zhiyong "zhywang@live.com"

WORKDIR /opt

# Install essantial tools
RUN apt-get update && dpkg --add-architecture i386 && apt-get install -y git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 openjdk-8-jdk-headless && apt-get clean

# Install Android SDK
ARG ANDROID_SDK_VERSION
ARG ANDROID_VERSION
ARG ANDROID_BUILD_TOOLS_VERSION

RUN wget -qO- http://dl.google.com/android/android-sdk_r$ANDROID_SDK_VERSION-linux.tgz | tar xzf - && chown -R root.root android-sdk-linux
RUN echo y | /opt/android-sdk-linux/tools/android update sdk --all --force --no-ui --filter platform-tools
RUN echo y | /opt/android-sdk-linux/tools/android update sdk --all --force --no-ui --filter build-tools-$ANDROID_BUILD_TOOLS_VERSION
RUN echo y | /opt/android-sdk-linux/tools/android update sdk --all --force --no-ui --filter android-$ANDROID_VERSION
RUN echo y | /opt/android-sdk-linux/tools/android update sdk --all --force --no-ui --filter extra-android-m2repository
RUN echo y | /opt/android-sdk-linux/tools/android update sdk --all --force --no-ui --filter extra-google-m2repository

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
ENV JVM_ARGS "-Xmx2048m -XX:MaxPermSize=1024m"
