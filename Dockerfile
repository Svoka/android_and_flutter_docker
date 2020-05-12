FROM openjdk:8-jdk

ENV ANDROID_COMPILE_SDK=29
ENV ANDROID_BUILD_TOOLS=29.0.3
ENV SDK_TOOLS=6200805
ENV EMULATOR_VERSION=24

ENV FLUTTER_VERSION="1.17.0"
ENV FLUTTER_ROOT="/opt/flutter"
ENV PATH="${FLUTTER_ROOT}/bin:${PATH}:/flutter/bin/cache/dart-sdk/bin:/flutter/bin"


RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS}_latest.zip
RUN unzip -q android-sdk.zip -d android-sdk-linux
RUN rm android-sdk.zip

ENV ANDROID_HOME=$PWD/android-sdk-linux
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV PATH=$PATH:$PWD/android-sdk-linux/platform-tools/

RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "tools"
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}" "extras;google;m2repository" "extras;android;m2repository"
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-28" "build-tools;28.0.3" "extras;google;m2repository" "extras;android;m2repository"

#RUN apt-get --quiet update --yes
#RUN apt-get --quiet install --yes libx11-dev libpulse0 libgl1 libnss3 libxcomposite-dev libxcursor1 libasound2
#RUN wget --quiet --output-document=android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/0f497eb71291b52a703143c5cd63a217c8766dc9/community-cookbooks/android-sdk/files/default/android-wait-for-emulator
#RUN chmod +x android-wait-for-emulator

#RUN ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" "emulator" "system-images;android-${EMULATOR_VERSION};default;armeabi-v7a"
#RUN echo no | ${ANDROID_HOME}/tools/bin/avdmanager create avd -n test -k "system-images;android-${EMULATOR_VERSION};default;armeabi-v7a"
#RUN adb start-server




# Install Flutter.
RUN git clone --branch $FLUTTER_VERSION --depth=1 https://github.com/flutter/flutter "${FLUTTER_ROOT}"
RUN flutter config  --no-analytics
RUN flutter precache

#android-sdk-linux/emulator/emulator -avd test -no-window -no-audio &
#./android-wait-for-emulator