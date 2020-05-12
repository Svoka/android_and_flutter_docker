FROM openjdk:8-jdk

ENV ANDROID_COMPILE_SDK=29
ENV ANDROID_BUILD_TOOLS=29.0.3
ENV SDK_TOOLS=6200805
ENV EMULATOR_VERSION=24

ENV FLUTTER_VERSION="1.17.0"
ENV FLUTTER_ROOT="/opt/flutter"
ENV PATH="${FLUTTER_ROOT}/bin:${PATH}:/flutter/bin/cache/dart-sdk/bin:/flutter/bin"


RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS}_latest.zip && \
unzip -q android-sdk.zip -d android-sdk-linux && \
rm android-sdk.zip

ENV ANDROID_HOME=$PWD/android-sdk-linux
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV PATH=$PATH:$PWD/android-sdk-linux/platform-tools/

RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses && \
${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "tools" && \
echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}" "extras;google;m2repository" "extras;android;m2repository" && \
echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-28" "build-tools;28.0.3" "extras;google;m2repository" "extras;android;m2repository"

RUN apt update -y && \
apt install -y  lcov && \
git clone --branch $FLUTTER_VERSION --depth=1 https://github.com/flutter/flutter "${FLUTTER_ROOT}" && \
flutter config  --no-analytics && \
flutter precache