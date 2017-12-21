FROM debian:stretch-slim

MAINTAINER Wang Zhiyong "zhywang@live.com"

WORKDIR /opt

# Install essantial tools
RUN apt-get update && dpkg --add-architecture i386 && mkdir -p /usr/share/man/man1 && apt-get install -y libc6-i386 lib32z1 git wget unzip openjdk-8-jre-headless openjdk-8-jdk-headless ca-certificates-java && apt-get clean

# Install Android SDK
ARG ANDROID_SDK_VERSION
ARG ANDROID_VERSION
ARG ANDROID_BUILD_TOOLS_VERSION

RUN mkdir android-sdk-linux &&\
 	wget -q https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_SDK_VERSION.zip &&\
 	unzip -qq -d android-sdk-linux sdk-tools-linux-$ANDROID_SDK_VERSION.zip &&\
 	chown -R root.root android-sdk-linux/tools &&\
 	rm -rf sdk-tools-linux-$ANDROID_SDK_VERSION.zip
RUN echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=./android-sdk-linux "platform-tools"
RUN echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=./android-sdk-linux "build-tools;$ANDROID_BUILD_TOOLS_VERSION"
RUN echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=./android-sdk-linux "platforms;android-$ANDROID_VERSION"

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install gradle
ARG GRADLE_VERSION
RUN wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && unzip -qq gradle-${GRADLE_VERSION}-bin.zip && rm -rf gradle-${GRADLE_VERSION}-bin.zip
ADD init.gradle gradle-${GRADLE_VERSION}/init.d/init.gradle
ENV PATH ${PATH}:/opt/gradle-${GRADLE_VERSION}/bin
# ENV JVM_ARGS "-Xmx2048m -XX:MaxPermSize=1024m"
