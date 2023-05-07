#!/bin/bash
#         _                  ____  ____ 
#        (_)________  ____  / __ \/ __ \
#       / / ___/ __ \/_  / / / / / / / /
#      / / /__/ /_/ / / /_/ /_/ / /_/ / 
#   __/ /\___/\____/ /___/\____/\____/  
#  /___/                                
#©2019-20 by James Cozzi All rights reserved
#Minecraft Server Installer and Executor (MSIE) for macOS
#Version 1.1
BASEDIR=$(dirname "$0")
cd $BASEDIR
installedcheck=$BASEDIR/Server/installcomplete
if [ -e "$installedcheck" ]; then
    cd $BASEDIR/Server
    open /Applications/Port\ Map.app
    mono64 McMyAdmin.exe
    killall Port\ Map
else
	memory=$(system_profiler SPHardwareDataType | grep Memory: | tr -d '      Memory: '| tr -d ' GB')
	echo "Checking installed memory..."
	sleep 3
	echo "Installed memory: $memory GB"
	sleep 3
	jdkcheck=/Library/Java/JavaVirtualMachines/
	echo "Checking for JDK..."
	sleep 3
if [ -e "$jdkcheck" ]; then
	echo "JDK is installed."
	sleep 3
	monocheck=/Library/Frameworks/Mono.framework/Versions/Current/Commands/mono64
	echo "Checking for Mono..."
	sleep 3
if [ -e "$monocheck" ]; then
	read -r -p "All checks complete. Install server? (Y/N) " checkresponse
if [[ "$checkresponse" =~ ^([yY][eE][sS]|[yY])+$ ]] 
	then
	sleep 2
	echo "Downloading and preparing server setup files..."
	mkdir serversetup
	cd $BASEDIR/serversetup
	curl -LO https://github.com/monkeydom/TCMPortMapper/releases/download/PortMap-2.0.1/PortMap-2.0.1-85.zip
	sleep 1
	unzip $BASEDIR/serversetup/PortMap-2.0.1-85.zip -d $BASEDIR/serversetup > /dev/null
	mv $BASEDIR/serversetup/Port\ Map.app /Applications > /dev/null
	mkdir $BASEDIR/Server > /dev/null
	cd $BASEDIR/Server
	curl -LO http://mcmyadmin.com/Downloads/MCMA2-Latest.zip
	sleep 1
	unzip $BASEDIR/Server/MCMA2-Latest.zip -d $BASEDIR/Server > /dev/null
	sleep 1
	cd $BASEDIR/serversetup
	curl -LO https://papermc.io/ci/job/Paper-1.15/lastStableBuild/artifact/paperclip.jar
	sleep 1
	rm -r $BASEDIR/Server/MCMA2-Latest.zip
	rm -r $BASEDIR/serversetup/__MACOSX
	rm -r $BASEDIR/serversetup/PortMap-2.0.1-85.zip
	sleep 2
	open /Applications/Port\ Map.app
	sleep 2
	killall Port\ Map
	sleep 1
# 	rootPath=$(pwd)
# 	cd $rootPath
	cd ~/Library/Containers/de.monkeydom.TCMPortMapper.PortMap/Data/Library/Preferences
	touch de.monkeydom.TCMPortMapper.PortMap.plist
	echo "<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>StoredMappings</key>
	<array>
		<dict>
			<key>desiredPublicPort</key>
			<integer>25565</integer>
			<key>privatePort</key>
			<integer>25565</integer>
			<key>transportProtocol</key>
			<integer>2</integer>
			<key>userInfo</key>
			<dict>
				<key>active</key>
				<true/>
				<key>mappingTitle</key>
				<string>Minecraft</string>
				<key>referenceString</key>
				<string></string>
			</dict>
		</dict>
		<dict>
			<key>desiredPublicPort</key>
			<integer>8080</integer>
			<key>privatePort</key>
			<integer>8080</integer>
			<key>transportProtocol</key>
			<integer>2</integer>
			<key>userInfo</key>
			<dict>
				<key>active</key>
				<true/>
				<key>mappingTitle</key>
				<string>McMyAdmin</string>
				<key>referenceString</key>
				<string></string>
			</dict>
		</dict>
	</array>
</dict>
</plist>
" > de.monkeydom.TCMPortMapper.PortMap.plist
	sleep 2
	open /Applications/Port\ Map.app
	# read -p "Enter ports 25565 and 8080 in local port field in port map and press enter when finished. "
	sleep 2
	echo "Opening Safari and initializing server..."
	sleep 3
	open -a "/Applications/Safari.app" 'http://127.0.0.1:8080'
    cd $BASEDIR/Server
	mono64 McMyAdmin.exe -setpass admin -configonly
	sleep 5
	mv $BASEDIR/serversetup/paperclip.jar $BASEDIR/Server/minecraft/spigot.jar > /dev/null
	sed -i '' "s/1024/$(($memory*1024/2))/g" McMyAdmin.conf > /dev/null
	sed -i '' "s/Official/Spigot/g" McMyAdmin.conf
	echo "Installation complete!"
	touch installcomplete > /dev/null
	rm -r $BASEDIR/serversetup
	sleep 5
	mono64 McMyAdmin.exe
	killall Port\ Map
else
	exit
fi	
else
	echo "Mono is not installed. Installing now."
	sleep 1
	cd $BASEDIR/serversetup
	curl -LO http://download.mono-project.com/archive/5.18.0/macos-10-universal/MonoFramework-MDK-5.18.0.240.macos10.xamarin.universal.pkg
	sudo installer -verbose -pkg $BASEDIR/serversetup/MonoFramework-MDK-5.18.0.240.macos10.xamarin.universal.pkg -target / > /dev/null
	echo "Please restart the installer to complete installation of Mono."
	exit
fi
else
	echo "You need to download and install JDK to use this tool. Linking you to it now..."
	sleep 4
	open -a "/Applications/Safari.app" 'https://www.oracle.com/technetwork/java/javase/downloads/index.html' > /dev/null
	exit
fi
fi