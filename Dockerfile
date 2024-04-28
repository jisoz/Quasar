
# after two days of trying to install Android SDK without knowing anything about android development
# I've resulted to use existing up to date (even though not too popular) docker image
# https://github.com/menny/docker_android
FROM menny/android:latest
#accepting sdk licences
RUN /opt/android-sdk-linux/cmdline-tools/latest/bin/sdkmanager  --licenses


# Update package list and install wget
RUN apt-get update && apt-get install -y wget

# Download and extract Gradle
RUN wget https://services.gradle.org/distributions/gradle-8.2.1-bin.zip && \
    unzip -d /usr/local gradle-8.2.1-bin.zip

# Download and extract Oracle JDK
RUN wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && \
    tar xvf jdk-17_linux-x64_bin.tar.gz -C /usr/local/

# Set environment variables
ENV PATH=$PATH:/usr/local/gradle-8.2.1/bin
ENV JAVA_HOME=/usr/local/jdk-17.0.8
ENV JDK_HOME=/usr/local/jdk-17.0.8
ENV STUDIO_JDK=/usr/local/jdk-17.0.8
ENV ANDROID_HOME=/opt/android-sdk-linux


# Display Gradle version
RUN gradle --version

# Set the working directory to /app
WORKDIR /appnotary
# Copy the rest of the Android project files to the container
COPY src-capacitor/android/gradlew /appnotary/src-capacitor/android/gradlew
COPY src-capacitor/android/gradle /appnotary/src-capacitor/android/gradle
COPY . .




# Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs
# Install Yarn
RUN npm install -g yarn
# install OS packages
RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes ruby ruby-dev
# We use this for xxd hex->binary
RUN apt-get --quiet install --yes vim-common
# install FastLane
COPY src-capacitor/android/Gemfile /appnotary/src-capacitor/android/Gemfile
COPY src-capacitor/android/Gemfile.lock /appnotary/src-capacitor/android/Gemfile.lock
WORKDIR /appnotary/src-capacitor/android

# RUN gem install bundler -v 2.3.26
RUN gem install bundler -v 2.4.17
RUN bundle install
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
