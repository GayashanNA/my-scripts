# if you want to skip the questions, pass "Y" as a command line argument when executing the script to mark YES TO ALL.
yesToAll=$1
clear
echo I am setting up the system...please sit back and relax, and press Y/n here and there.
sudo apt-get update -qq && sudo apt-get upgrade -y -qq
echo Installing xubuntu restricted extras
sudo apt-get install -y -qq xubuntu-restricted-extras libavcodec-extra
echo
echo Fix any broken packages
sudo apt-get -y dist-upgrade
sudo apt-get -y -qq install -f
echo
echo Installing required software packages
sudo apt-get -y -qq install vim
echo Setting up vimrc file
wget -P /tmp/ https://raw.githubusercontent.com/GayashanNA/myvim/master/.vimrc
cp -v /tmp/.vimrc ~/.vimrc
echo
echo Do you want to install Google chrome? Y/n
read installGoogleChrome
if [ "$yesToAll" == "Y" ] || [ "$installGoogleChrome" != "n" ]; then
	sudo apt-get -y -qq install libxss1 libappindicator1 libindicator7
	wget -P /tmp/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i /tmp/google-chrome*.deb
    # sometimes the chrome installation gives an error with missing packages.
    # I'm lazy to catch that error and rerun chrome installation.
    # Instead I'll rerun chrome installation always. :)
	sudo apt-get -y -qq install -f
	sudo dpkg -i /tmp/google-chrome*.deb
fi
echo
echo Adding Kodi repositories
sudo add-apt-repository -y -u ppa:team-xbmc/ppa
echo installing video players
sudo apt-get install -y -qq vlc kodi
echo
echo Do you want to install git and set it up? Y/n
read installGit
if [ "$yesToAll" == "Y" ] || [ "$installGit" != "n" ]; then
	sudo apt-get -y -qq install git gitk
	echo What is your Git user name?
	read gitUserName
	git config --global user.name "$gitUserName"
	echo What is your Git email address?
	read gitEmail
	git config --global user.email "$gitEmail"
	git config --global core.editor vim
	git config --global credential.helper cache
    # set the credential cache to timeout after 5hrs.
    git config --global credential.helper 'cache --timeout=18000'
    git config --list
fi
echo
# jdk 1.8.0_121 is the latest jdk 8 release as of March 2017. So if you want the latest jdk, fix the url and directories that follow accordingly with the latest release version number..
# Unfortunately oracle do not provide a direct download link for the latest jdk. :(
# If this part of the script is not working, then check the download url in the wget.
echo Do you want to download and setup jdk 8? Y/n
read downloadJava8
if [ "$yesToAll" == "Y" ] || [ "$downloadJava8" != "n" ]; then
    wget -P /tmp/ --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
    tar -xvzf /tmp/jdk-8u121-linux-x64.tar.gz
    sudo mkdir /usr/lib/jvm
    sudo mv /tmp/jdk1.8.0_121 /usr/lib/jvm/
    sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.8.0_121/bin/javac 1
    sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_121/bin/java 1
    sudo update-alternatives --install /usr/bin/javaws javaws /usr/lib/jvm/jdk1.8.0_121/bin/javaws 1
    
    ls -la /etc/alternatives/java*
fi
# jdk 1.7.0_80 is the last jdk 7 release from oracle. So if this part of the script is not working, then most probably the download url is broken.
echo Do you want to download and setup jdk 7? Y/n
read downloadJava7
if [ "$yesToAll" == "Y" ] || [ "$downloadJava7" != "n" ]; then
    wget -P /tmp/ --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz
    tar -xvzf /tmp/jdk-7u80-linux-x64.tar.gz
    sudo mkdir /usr/lib/jvm
    sudo mv /tmp/jdk1.7.0_80 /usr/lib/jvm/
    sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.7.0_80/bin/javac 1
    sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.7.0_80/bin/java 1
    sudo update-alternatives --install /usr/bin/javaws javaws /usr/lib/jvm/jdk1.7.0_80/bin/javaws 1
    
    ls -la /etc/alternatives/java*
fi
echo
echo Do you want to install darktable? Y/n
read installDarktable
if [ "$yesToAll" == "Y" ] || [ "$installDarktable" != "n" ]; then
	sudo apt-get install -y -qq darktable
fi
echo Installing python utulities
sudo apt-get -y -qq install python-pip
sudo -H pip install pip --upgrade
sudo -H pip2 install httplib2 --upgrade
echo
echo Fixing broken packages
sudo apt-get -y -qq install -f
echo
echo Cleaning packages that are not required anymore
sudo apt-get -y -qq autoremove
echo
if [ "$downloadJava7" != "n" ] || [ "$downloadJava8" != "n" ]; then
    echo Choose default java
    sudo update-alternatives --config javac
    sudo update-alternatives --config java
    sudo update-alternatives --config javaws
fi
echo Initial setup is completed!
echo Thank you.
