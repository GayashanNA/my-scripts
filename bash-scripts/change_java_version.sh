#!/bin/bash
__java_version=${1:-"7"}
if [ "$__java_version" == "7" ]; then
    echo Moving to java 7
    sudo update-alternatives --set javac /usr/lib/jvm/jdk1.7.0_80/bin/javac
    sudo update-alternatives --set java /usr/lib/jvm/jdk1.7.0_80/bin/java
    sudo update-alternatives --set javaws /usr/lib/jvm/jdk1.7.0_80/bin/javaws
elif [ "$__java_version" == "8" ]; then
    echo Moving to java 8
    sudo update-alternatives --set javac /usr/lib/jvm/jdk1.8.0_121/bin/javac
    sudo update-alternatives --set java /usr/lib/jvm/jdk1.8.0_121/bin/java
    sudo update-alternatives --set javaws /usr/lib/jvm/jdk1.8.0_121/bin/javaws
fi

java -version
echo Java version is set to ${__java_version}
echo Please set the JAVA_HOME environment variable accordingly.
