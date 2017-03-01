FROM ubuntu:16.04

MAINTAINER Wang Zhiyong "zhywang@live.com"

WORKDIR /opt

# Install essantial tools
RUN apt-get update && dpkg --add-architecture i386 && apt-get install -y git wget unzip libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 openjdk-8-jdk-headless && apt-get clean

# Install Android SDK
ARG ANDROID_SDK_VERSION
ARG ANDROID_VERSION
ARG ANDROID_BUILD_TOOLS_VERSION

RUN mkdir android-sdk-linux &&\
 	wget -q https://dl.google.com/android/repository/tools_r$ANDROID_SDK_VERSION-linux.zip &&\
 	unzip -d android-sdk-linux tools_r$ANDROID_SDK_VERSION-linux.zip &&\
 	chown -R root.root android-sdk-linux/tools &&\
 	rm -rf tools_r$ANDROID_SDK_VERSION-linux.zip
RUN echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=/opt/android-sdk-linux "platform-tools"
RUN echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=/opt/android-sdk-linux "build-tools;$ANDROID_BUILD_TOOLS_VERSION"
RUN echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=/opt/android-sdk-linux "platforms;android-$ANDROID_VERSION"
RUN echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=/opt/android-sdk-linux "extras;android;m2repository"
RUN echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=/opt/android-sdk-linux "extras;google;m2repository"
RUN echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=/opt/android-sdk-linux "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.0"
RUN echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=/opt/android-sdk-linux "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0"

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
# ENV JVM_ARGS "-Xmx2048m -XX:MaxPermSize=1024m"
