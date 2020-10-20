#!/bin/bash
__java_version=${1:-"8"}
__JDK_VER=jdk1.8.0_221
if [ "$__java_version" == "7" ]; then
    echo Moving to java 7
    sudo update-alternatives --set javac /usr/lib/jvm/jdk1.7.0_80/bin/javac
    sudo update-alternatives --set java /usr/lib/jvm/jdk1.7.0_80/bin/java
    sudo update-alternatives --set javaws /usr/lib/jvm/jdk1.7.0_80/bin/javaws
elif [ "$__java_version" == "8" ]; then
    echo Moving to java 8
    sudo update-alternatives --set javac /usr/lib/jvm/${__JDK_VER}/bin/javac
    sudo update-alternatives --set java /usr/lib/jvm/${__JDK_VER}/bin/java
    sudo update-alternatives --set javaws /usr/lib/jvm/${__JDK_VER}/bin/javaws
fi

java -version
echo Java version is set to ${__java_version}
$(pwd)
echo Please set the JAVA_HOME environment variable accordingly.
