FROM ubuntu
MAINTAINER Anna Kruglik <kruglik.anna@gmail.com>

# Oracle java 8
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
		oracle-java8-installer

# Install apache ant
RUN apt-get -y install ant

# Environment variables
ENV ANDROID_SDK_HOME /opt/android-sdk-linux
ENV ANDROID_HOME $ANDROID_SDK_HOME
ENV PATH $PATH:$ANDROID_SDK_HOME/tools
ENV PATH $PATH:$ANDROID_SDK_HOME/platform-tools

# Install android sdk
ENV ANDROID_SDK_VERSION r24.3.3
RUN wget http://dl.google.com/android/android-sdk_$ANDROID_SDK_VERSION-linux.tgz && \
    tar -xvzf android-sdk_$ANDROID_SDK_VERSION-linux.tgz -C /opt && \
	rm -f android-sdk_$ANDROID_SDK_VERSION-linux.tgz

# Running many at the same time was causing problems. So, running one-by-one:
RUN echo y | android update sdk --no-https --all --no-ui --force --filter android-22 && \
    echo y | android update sdk --no-https --all --no-ui --force --filter tools && \
    echo y | android update sdk --no-https --all --no-ui --force --filter platform-tools && \
    echo y | android update sdk --no-https --all --no-ui --force --filter build-tools-22.0.1 && \
    echo y | android update sdk --no-https --all --no-ui --force --filter addon-google_apis-google-22

# Clean up
RUN apt-get clean

# Install vim & unzip
RUN apt-get -y install unzip
RUN apt-get -y install npm 

RUN ln -s /usr/bin/nodejs /usr/bin/node

# Download XWalk build tool
ENV XWALK_VERSION 14.43.343.17
RUN wget --no-check-certificate \
	https://download.01.org/crosswalk/releases/crosswalk/android/stable/$XWALK_VERSION/crosswalk-$XWALK_VERSION.zip && \
	unzip crosswalk-$XWALK_VERSION.zip && \
	rm crosswalk-$XWALK_VERSION.zip

# Install ia-32libs dependency
RUN apt-get -y install lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6

# Add build script to the container
ADD build.sh /
CMD /bin/sh /build.sh
