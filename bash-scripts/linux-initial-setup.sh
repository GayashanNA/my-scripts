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
if [ "${__xubuntu_restricted_extras}" == "Y" ]; then
    echo INFO: Installing xubuntu restricted extras
    sudo apt-get install -y -qq xubuntu-restricted-extras libavcodec-extra
fi
echo INFO: Installing required software packages
sudo apt-get -y -qq install ${__applications_to_install}
echo INFO: Setting up vimrc file
wget -P /tmp/vim ${__vim_config_dl_url} 
cp -v /tmp/vim/.vimrc ~/.vimrc
if [ "${__google_chrome}" == "Y" ]; then
    echo INFO: Installing Google Chrome
    sudo apt-get -y -qq install libxss1 libappindicator1 libindicator7
    wget -P /tmp/chrome ${__google_chrome_dl_url}
    sudo dpkg -i /tmp/chrome/google-chrome*.deb
    # sometimes the chrome installation gives an error with missing packages.
    # I'm lazy to catch that error and rerun chrome installation.
    # Instead I'll rerun chrome installation always. :)
    sudo apt-get -y -qq install -f
    sudo dpkg -i /tmp/chrome/google-chrome*.deb
fi
if [ "${__kodi}" == "Y" ]; then
    echo INFO: Installing Kodi
    sudo add-apt-repository -y -u ppa:team-xbmc/ppa
    sudo apt-get install -y -qq kodi
fi
if [ "${__git}" == "Y" ]; then
    echo INFO: Installing and setting up git
    sudo apt-get -y -qq install git gitk
    git config --global user.name "${__git_username}"
    git config --global user.email "${__git_email}"
    git config --global core.editor vim
    git config --global credential.helper cache
    # set the credential cache to timeout after 5hrs.
    git config --global credential.helper 'cache --timeout='${__git_cache_timeout}
    git config --list
fi
# jdk 1.8.0_121 is the latest jdk 8 release as of March 2017. So if you want the latest jdk, 
# fix the url and directories that follow accordingly with the latest release version number.
# Unfortunately oracle do not provide a direct download link for the latest jdk. :(
# If this part of the script is not working, then check the download url in the wget.
if [ "${__java8}" == "Y" ]; then
    echo INFO: Installing and setting up java 8
    wget -P /tmp/j8/ --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" ${__java8_dl_url}
    tar -xvzf /tmp/j8/jdk-8*.tar.gz
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
    tar -xvzf /tmp/j7/jdk-7u80-linux-x64.tar.gz
    sudo mkdir /usr/lib/jvm
    sudo mv /tmp/j7/${__java7_dl_extract_dir} /usr/lib/jvm/
    sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/${__java7_dl_extract_dir}/bin/javac 1
    sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/${__java7_dl_extract_dir}/bin/java 1
    sudo update-alternatives --install /usr/bin/javaws javaws /usr/lib/jvm/${__java7_dl_extract_dir}/bin/javaws 1
    ls -la /etc/alternatives/java*
fi
if [ "${__dark_table}" == "Y" ]; then
    echo INFO: Installing Darktable
    sudo apt-get install -y -qq darktable
fi
if [ "${__spotify}" == "Y" ]; then
    echo INFO: Installing spotify
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
    echo INFO: deb ${__spotify_dl_url} stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update
    sudo apt-get -y -qq install spotify-client
fi
if [ "${__python_utilities}" == "Y" ]; then
    echo INFO: Installing python-pip
    sudo apt-get -y -qq install python-pip
    sudo -H pip install pip --upgrade
    sudo -H pip2 install httplib2 --upgrade
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
echo INFO: Initial setup is completed!
echo INFO: Thank you.
