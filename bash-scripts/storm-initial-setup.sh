#!/bin/bash

clear
if [ ! -f linux-init-properties.cfg ]; then
    echo ERROR: Configuration file linux-init-properties.cfg is not available. Aborting setup...
    exit 1
else
    . linux-init-properties.cfg
fi
echo INFO: I am setting up the system...sit back, relax and enjoy the ride.
sudo apt-get update -y -qq
sudo apt-get -y dist-upgrade
sudo apt-get -y -qq install -f
sudo apt -y -qq autoremove
echo INFO: Installing required software packages
sudo apt-get -y -qq install ${__applications_to_install}
echo INFO: Setting up vimrc file
wget -P /tmp/vim ${__vim_config_dl_url} 
cp -v /tmp/vim/.vimrc ~/.vimrc
# jdk 1.8.0_121 is the latest jdk 8 release as of March 2017. So if you want the latest jdk, 
# fix the url and directories that follow accordingly with the latest release version number.
# Unfortunately oracle do not provide a direct download link for the latest jdk. :(
# If this part of the script is not working, then check the download url in the wget.
if [ "${__java8}" == "Y" ]; then
    echo INFO: Installing and setting up java 8
    wget -P /tmp/j8/ --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" ${__java8_dl_url}
    tar -xvzf /tmp/j8/jdk-8*.tar.gz -C /tmp/j8/
    sudo mkdir /usr/lib/jvm
    sudo mv /tmp/j8/${__java8_dl_extract_dir} /usr/lib/jvm/
    sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/${__java8_dl_extract_dir}/bin/javac 1
    sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/${__java8_dl_extract_dir}/bin/java 1
    sudo update-alternatives --install /usr/bin/javaws javaws /usr/lib/jvm/${__java8_dl_extract_dir}/bin/javaws 1
    ls -la /etc/alternatives/java*
fi
# jdk 1.7.0_80 is the last jdk 7 release from oracle. So if this part of the script is not working,
# then most probably the download url is broken.
if [ "${__java7}" == "Y" ]; then
    echo INFO: Installing and setting up java 7
    wget -P /tmp/j7/ --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" ${__java7_dl_url}
    # no need to generalize the file name since this is the last version to be released.
    tar -xvzf /tmp/j7/jdk-7u80-linux-x64.tar.gz -C /tmp/j7/
    sudo mkdir /usr/lib/jvm
    sudo mv /tmp/j7/${__java7_dl_extract_dir} /usr/lib/jvm/
    sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/${__java7_dl_extract_dir}/bin/javac 1
    sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/${__java7_dl_extract_dir}/bin/java 1
    sudo update-alternatives --install /usr/bin/javaws javaws /usr/lib/jvm/${__java7_dl_extract_dir}/bin/javaws 1
    ls -la /etc/alternatives/java*
fi
echo INFO: Fixing broken packages
sudo apt-get -y -qq install -f
echo INFO: Cleaning packages that are not required anymore
sudo apt-get -y -qq autoremove
if [ "${__default_java}" == "7" ]; then
    echo INFO: Default is java 7
    sudo update-alternatives --set javac /usr/lib/jvm/${__java7_dl_extract_dir}/bin/javac
    sudo update-alternatives --set java /usr/lib/jvm/${__java7_dl_extract_dir}/bin/java
    sudo update-alternatives --set javaws /usr/lib/jvm/${__java7_dl_extract_dir}/bin/javaws
elif [ "${__default_java}" == "8" ]; then
    echo INFO: Default is java 8
    sudo update-alternatives --set javac /usr/lib/jvm/${__java8_dl_extract_dir}/bin/javac
    sudo update-alternatives --set java /usr/lib/jvm/${__java8_dl_extract_dir}/bin/java
    sudo update-alternatives --set javaws /usr/lib/jvm/${__java8_dl_extract_dir}/bin/javaws
fi

mkdir /home/ubuntu/bin/
mkdir /home/ubuntu/bin/zookeeper/
mkdir /home/ubuntu/bin/storm/
mkdir /home/ubuntu/bin/kafka/
cd /home/ubuntu/bin/

wget -P /tmp/ http://apache.mirror.amaze.com.au/zookeeper/zookeeper-3.5.5/apache-zookeeper-3.5.5.tar.gz 
tar -xvzf /tmp/apache-zookeeper-3.5.5.tar.gz -C /tmp/
mv /tmp/apache-zookeeper-3.5.5/ /home/ubuntu/bin/zookeeper/

wget -P /tmp/ https://archive.apache.org/dist/storm/apache-storm-0.10.0/apache-storm-0.10.0.tar.gz
tar -xvzf /tmp/apache-storm-0.10.0.tar.gz -C /tmp/
mv /tmp/apache-storm-0.10.0/ /home/ubuntu/bin/storm/

wget -P /tmp/ http://apache.mirror.amaze.com.au/kafka/2.2.1/kafka-2.2.1-src.tgz
tar -xvzf /tmp/kafka-2.2.1-src.tgz -C /tmp/
mv /tmp/kafka-2.2.1-src/ /home/ubuntu/bin/kafka/

wget -P /tmp/ https://repo.mongodb.org/apt/ubuntu/dists/xenial/mongodb-org/4.2/multiverse/binary-amd64/mongodb-org-server_4.2.0_amd64.deb
sudo dpkg -i /tmp/mongodb-org-server_4.2.0_amd64.deb

echo INFO: Initial setup is completed!
echo "export JAVA_HOME=/usr/lib/jvm/${__java8_dl_extract_dir}" >> /home/ubuntu/.bashrc
echo INFO: Thank you.
