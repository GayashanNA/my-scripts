isYesToAll=$1
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
read isGoogleChrome
if [ "$isYesToAll" == "Y" ] || [ "$isGoogleChrome" != "n" ]; then
	sudo apt-get -y -qq install libxss1 libappindicator1 libindicator7
	wget -P /tmp/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i /tmp/google-chrome*.deb
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
read isGit
if [ "$isYesToAll" == "Y" ] || [ "$isGit" != "n" ]; then
	sudo apt-get -y -qq install git
	echo What is your Git user name?
	read gitUserName
	git config --global user.name "$gitUserName"
	echo What is your Git email address?
	read gitEmail
	git config --global user.email "$gitEmail"
	git config --global core.editor vim
	git config --list
fi
echo
echo Do you want to install darktable? Y/n
read isDarktable
if [ "$isYesToAll" == "Y" ] || [ "$isDarktable" != "n" ]; then
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
echo Initial setup is completed!
echo Thank you.
