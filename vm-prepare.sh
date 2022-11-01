#!/bin/bash 
OKBLUE='\033[94m'
OKRED='\033[91m'
OKGREEN='\033[92m'
OKORANGE='\033[93m'
RESET='\e[0m'

#if [ -z $1 ]; then
#	echo "Please enter a backup file name"
#	echo
#	echo "=============================="	
#	echo
#	exit
#fi

#Check
#https://github.com/penetrarnya-tm/WeaponizeKali.sh

identity=$(whoami)
depedencies=""
TOOLSFOLDER="/opt/outils"
BIGAPPS="/opt"
INITPWD=$(pwd)
HOSTDOCUMENTS="~/HostDocuments"


printhelp(){
	echo "USAGE:
	vm-prepare firsttime|all

	firsttime 	installs the prerequisites (to be run the firsttime only)
	all		installs all the tools


Notes:
	tools will be installed using following variables: 
	TOOLSFOLDER=$TOOLSFOLDER
	identity=$identity
	"
}


if [ "$identity" = "root" ]; then
	SUDO=""
else
	SUDO="sudo"
fi




#Do the following only once the first time:
firsttime(){
    $SUDO apt-get update
    $SUDO apt-get -y upgrade

# ORACLE JAVA:
    #$SUDO add-apt-repository ppa:webupd8team/java
    #$SUDO apt-get install oracle-java8-installer  #ne fonctionne pas bien

# FOR ME:
    depedencies="$depedencies make ruby vim git gitk"
    depedencies="$depedencies gparted libemu2 meld dia"
    depedencies="$depedencies hping3 tcpreplay apache2-utils"
    depedencies="$depedencies opensc"
    depedencies="$depedencies linux-source"
    depedencies="$depedencies exuberant-ctags cscope"
    depedencies="$depedencies wireshark"
    depedencies="$depedencies silversearcher-ag"
# FOR Bureautique
    depedencies="$depedencies filezilla"
# X86 COMPAT
    #depedencies="$depedencies libc6:i386 libstdc++6:i386 libc6-dev"
# WINDOWS PENTEST USEFUL STUFF
    depedencies="$depedencies rar kwrite unzip"
    depedencies="$depedencies xfce4 xubuntu-desktop"
    depedencies="$depedencies apt-file curl terminator kate tmux"
    depedencies="$depedencies python-libpcap"
    depedencies="$depedencies tshark"
    depedencies="$depedencies rdate krb5-user"
    depedencies="$depedencies mercurial"
    depedencies="$depedencies nagios-nrpe-plugin"
    depedencies="$depedencies traceroute tcptraceroute whois"
    depedencies="$depedencies krb5-user"
# FOR DNSENUM
    depedencies="$depedencies cpanminus libnet-netmask-perl libxml-writer-perl libstring-random-perl"
# FOR HYDRA
    depedencies="$depedencies libssl-dev libssh-dev libidn11-dev libpcre3-dev libgtk2.0-dev libmysqlclient-dev libpq-dev libsvn-dev firebird-dev"
# FOR ARACHNI
    depedencies="$depedencies build-essential curl libcurl4 libcurl4-openssl-dev ruby ruby-dev"
# FOR fragrouter
    depedencies="$depedencies flex bison"
# FOR PYTBULL
    depedencies="$depedencies python-cherrypy3 python-feedparser"
# FOR MALLORY
    depedencies="$depedencies python-m2crypto python-qt4 pyro-gui python-netfilter python-pyasn1 python-paramiko python-twisted-web python-qt4-sql sqlite3 build-essential libnetfilter-conntrack-dev libnetfilter-conntrack3"
#FOR ISIC
    depedencies="$depedencies libnet1-dev make"
# Windows CRACKING
    depedencies="$depedencies samdump2"
# FOR BINWALK
    depedencies="$depedencies python-lzma"
# FOR ENUM4LINUX
    depedencies="$depedencies smbclient" #rpcclient,net,nmblookup,smbclient
    depedencies="$depedencies ldap-utils" #ldapclient
    depedencies="$depedencies nbtscan"
# PYTHON USEFUL STUFF
    depedencies="$depedencies python-pip python-dev build-essential"
    depedencies="$depedencies ant"
    $SUDO apt-get -y install "$depedencies"
    echo ""

#TODO: Check the sources.list

# NESSUS RESTORE
# tar -xzf $1
# nessus-restore.sh nessus_backup.tar.gz

# Recompile vmtools kernel modules? The following is to be tested:
#git clone https://github.com/rasa/vmware-tools-patches.git ~/vmware-tools-patches
#cd ~/vmware-tools-patches
#$SUDO ./download-tools.sh
#$SUDO ./untar-and-patch.sh
#$SUDO ./compile.sh

#TODO: Prepare with following:
# https://github.com/LionSec/katoolin
# https://github.com/g0tmi1k/os-scripts

#Need to install jython (2.5.3) for burp

    git config --global user.email "romain.carnus@gmail.com"
    git config --global user.name "Romain Carnus"
    git config --global core.editor vim
    git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"

# VIM SETUP
    echo "Tuning the vimrc ..."
    cp $INITPWD/vimrc ~/.vimrc
    echo "Installing vim-plugin manager (vim-plug):"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'python-mode/python-mode', { 'branch': 'develop' }
Plug 'altercation/vim-colors-solarized'
Plug 'mileszs/ack.vim'
call plug#end()
" >> ~/.vimrc
    #Automatic replace when file opens
    echo "
if has(\"autocmd\")
  au BufReadPost * if line(\"'\\\"\") > 0 && line(\"'\\\"\") <= line(\"\$\")
    \\| exe \"normal! g'\\\"\" | endif
endif
" >> ~/.vimrc
    #Make vim look better
    echo "
let g:solarized_termcolors=256
syntax enable
set background=dark
colorscheme solarized
" >> ~/.vimrc
    #Search plugin (greps)
    echo "
let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack
:nmap <c-f> :Ack!
:imap <c-f> <Esc>:Ack!
" >> ~/.vimrc
    #Easy search and replace
    echo "
:nmap <c-g> :%s///g
:imap <c-g> <Esc>:%s///g
" >> ~/.vimrc
    #Quickfix window (for ack and others)
    echo "
\"Quickfix windows easy navigation
:nmap <c-n> :cn<CR>
:imap <c-n> <Esc>:cn<CR>
:nmap <c-p> :cp<CR>
:imap <c-p> <Esc>:cp<CR>
" >> ~/.vimrc
    echo "done"

# FOR WIRESHARK
	echo "Configuring wireshark ..."
	$SUDO dpkg-reconfigure wireshark-common
	$SUDO usermod -a -G wireshark $identity
	echo "done"
	echo ""

# PYTHON USEFUL STUFF
	echo "Updating pip and classic dependencies ..."
	$SUDO pip3 install --upgrade pip
	$SUDO pip3 install --upgrade virtualenv
	echo "done"
	echo ""


#Add go bins to PATH
	echo 'export PATH="$PATH:$HOME/go/bin"' >> $HOME/.zshrc
}



# JAVA: do not do that automatically
# $SUDO apt-get purge default-jdk openjdk-7-jdk openjdk-6-jdk
# $SUDO apt-get remove default-jdk icedtea-6-plugin icedtea-7-plugin
# $INITPWD/install-java.sh

# WEB-SHELLS
# Warning: les shells n'ont pas été vérifiés et peuvent potentiellement ouvrir des backdoors!
# git clone https://github.com/tennc/webshell $TOOLSFOLDER/web/Webshell/webshells-git

#Method of installation:
installtool(){
    ERROR=0
	echo -e "$OKBLUE Installing $1 in $2: $RESET"
	#check the existance of dir $2
	if [ ! -d "$TOOLSFOLDER/$2" ]; then
	#TODO: if it does not exist
	#lets ask the user if we should create it
	#if yes create it
	#else exit
		echo "$TOOLSFOLDER/$2 does not exist. Do you want to create it?"
		#read RESPONSE
		mkdir "$TOOLSFOLDER/$2"
	fi
	for DIR in "$TOOLSFOLDER/$2/$1"*; do
		if [ ! -d "$DIR" ]; then
			"install$1" "$2"
			ERROR=$?
			if [ $ERROR -ne 0 ]; then
				#TODO: redirect that on stderr 1>&2
				echo -e "$RED[!] Issue during installation of $1 $RESET"
				$SUDO rm -R "$TOOLSFOLDER/$2/$1"
				exit 1
			else
				echo -e "$OKGREEN Installation of $1 done $RESET"
			fi
		else
			echo -e "$OKORANGE Previous installation of $1 detected $RESET"
		fi
		break
	done
    echo ""
    echo ""
}


if [ "$1" = "firsttime" ]; then
	firsttime
	exit
elif [ "$1" = "all" ]; then
	echo "" # do Nothing
else
	printhelp
	exit
fi

# check that: https://github.com/mainframed/ptf

#TODO: check function
#see if this script has been run once aleady

#
## Standard Install Receipes:
#
installamass(){
	git clone https://github.com/OWASP/Amass.git "$TOOLSFOLDER/$1/amass"
	wget https://github.com/OWASP/Amass/releases/download/v3.14.0/amass_linux_amd64.zip -O "$TOOLSFOLDER/$1/amass/amass_linux_amd64.zip"
	cd "$TOOLSFOLDER/$1/amass"
	unzip amass_linux_amd64.zip
}
installsubfinder(){
	git clone https://github.com/projectdiscovery/subfinder.git "$TOOLSFOLDER/$1/subfinder"
	go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
	ln -s $HOME/go/bin/subfinder "$TOOLSFOLDER/$1/subfinder/subfinder"
}
installgau(){
	mkdir "$TOOLSFOLDER/$1/gau"
	GO111MODULE=on go get -u -v github.com/lc/gau
	ln -s $HOME/go/bin/gau "$TOOLSFOLDER/$1/gau/gau"
}
installikeprobe(){
	mkdir "$TOOLSFOLDER/$1/ikeprobe"
	wget www.ernw.de/download/ikeprobe.zip -O "$TOOLSFOLDER/$1/ikeprobe/ikeprobe.zip"
	cd "$TOOLSFOLDER/$1/ikeprobe"
	unzip ikeprobe.zip
}
installtheHarvester(){
	git clone https://github.com/laramies/theHarvester.git "$TOOLSFOLDER/$1/theHarvester"
	cd "$TOOLSFOLDER/$1/theHarvester"
	pip3 install -r requirements.txt
	python3 setup.py install
}
installdnsenum(){
	git clone https://github.com/fwaeytens/dnsenum.git "$TOOLSFOLDER/$1/dnsenum"
	chmod +x "$TOOLSFOLDER/$1/dnsenum/dnsenum.pl"
	$SUDO ln -s "$TOOLSFOLDER/$1/dnsenum/dnsenum.pl" /usr/bin/dnsenum
	cpanm String::Random
}
installdnsrecon(){
	git clone https://github.com/darkoperator/dnsrecon.git "$TOOLSFOLDER/$1/dnsrecon"
	cd "$TOOLSFOLDER/$1/dnsrecon"
	$SUDO pip install -r requirements.txt
	$SUDO ln -s "$TOOLSFOLDER/$1/dnsrecon/dnsrecon.py" /usr/bin/dnsrecon
}
installcloud_enum(){
	git clone https://github.com/initstring/cloud_enum.git "$TOOLSFOLDER/$1/cloud_enum"
}
installgitleaks(){
	git clone https://github.com/zricethezav/gitleaks.git "$TOOLSFOLDER/$1/gitleaks"
	GO111MODULE=on go get github.com/zricethezav/gitleaks/v7
	ln -s $HOME/go/bin/gitleaks "$TOOLSFOLDER/$1/nuclei/gitleaks"
}

installPCredz(){
	git clone https://github.com/lgandx/PCredz "$TOOLSFOLDER/$1/PCredz"
	$SUDO apt install python3-pip && $SUDO apt-get install libpcap-dev && $SUDO pip3 install Cython && $SUDO pip3 install python-libpcap
}
installntlmsspparse(){
	git clone https://github.com/psychomario/ntlmsspparse.git "$TOOLSFOLDER/$1/ntlmsspparse"
}
installntlmdecoder(){
	mkdir "$TOOLSFOLDER/$1/ntlmdecoder/"
	wget https://gist.githubusercontent.com/aseering/829a2270b72345a1dc42/raw/3f6fb735349ae848b4da3333d1ec10f89a0fb772/ntlmdecoder.py -O "$TOOLSFOLDER/$1/ntlmdecoder/ntlmdecoder.py"
}
installCredCrack(){
	git clone https://github.com/gojhonny/CredCrack.git "$TOOLSFOLDER/$1/CredCrack"
}
installRIDENUM(){
	git clone https://github.com/trustedsec/ridenum "$TOOLSFOLDER/$1/RIDENUM"
}
installpykek(){
	git clone https://github.com/bidord/pykek/ "$TOOLSFOLDER/$1/pykek"
}
installmimikatz(){
	git clone https://github.com/gentilkiwi/mimikatz.git "$TOOLSFOLDER/$1/mimikatz"
}
installrdp-check-sec(){
	git clone https://github.com/portcullislabs/rdp-sec-check.git "$TOOLSFOLDER/$1/rdp-check-sec"
	cpan install Encoding::BER
}
installwinexe(){
	wget http://downloads.sourceforge.net/project/winexe/winexe-1.00.tar.gz -O "$TOOLSFOLDER/$1/winexe-1.00.tar.gz"
	cd "$TOOLSFOLDER/$1/"
	tar -xf winexe-1.00.tar.gz
}
installcrackmapexec(){
	$SUDO apt-get install -y libssl-dev libffi-dev python-dev build-essential
	#git clone --recursive https://github.com/byt3bl33d3r/CrackMapExec "$TOOLSFOLDER/$1/crackmapexec"

	#mkdir "$TOOLSFOLDER/$1/crackmapexec"
	#wget https://github.com/byt3bl33d3r/CrackMapExec/releases/download/v5.1.7dev/cme-ubuntu-latest.zip -O "$TOOLSFOLDER/$1/crackmapexec/cme-ubuntu-latest.zip"
	#cd "$TOOLSFOLDER/$1/crackmapexec"
	#unzip cme-ubuntu-latest.zip

	python3 -m pip install pipx
	pipx ensurepath
	pipx install crackmapexec
}
installprivexchange(){
	git clone https://github.com/dirkjanm/PrivExchange.git "$TOOLSFOLDER/$1/privexchange"
}
installbloodhound-python(){
	git clone https://github.com/fox-it/BloodHound.py.git "$TOOLSFOLDER/$1/bloodhound-python"
	pip3 install bloodhound
}
installBloodHound(){
	git clone https://github.com/BloodHoundAD/BloodHound.git "$TOOLSFOLDER/$1/BloodHound"
	wget https://github.com/BloodHoundAD/BloodHound/releases/download/4.0.3/BloodHound-linux-x64.zip -O "$TOOLSFOLDER/$1/BloodHound/BloodHound-linux-x64-4.0.3.zip"
	cd "$TOOLSFOLDER/$1/BloodHound/"
	unzip "BloodHound-linux-x64-4.0.3.zip"
	$SUDO apt install neo4j -y
}
installgoddi(){
	mkdir "$TOOLSFOLDER/$1/goddi"
	wget https://github.com/NetSPI/goddi/releases/download/v1.2/goddi-linux-amd64 -O "$TOOLSFOLDER/$1/goddi/goddi-linux-amd64"
	chmod +x "$TOOLSFOLDER/$1/goddi/goddi-linux-amd64"
	$SUDO mkdir /mnt/goddi
}
installPetitPotam(){
	git clone https://github.com/topotam/PetitPotam.git "$TOOLSFOLDER/$1/PetitPotam"
}
installkerbrute(){
	git clone https://github.com/ropnop/kerbrute.git "$TOOLSFOLDER/$1/kerbrute"
}
installDachshundAD(){
	git clone git@github.com:GoSecure/DachshundAD.git "$TOOLSFOLDER/$1/DachshundAD"
}
installPKINITtools(){
	git clone https://github.com/dirkjanm/PKINITtools.git "$TOOLSFOLDER/$1/PKINITtools"
}
installKrbRelayUp(){
	git clone https://github.com/Dec0ne/KrbRelayUp.git "$TOOLSFOLDER/$1/KrbRelayUp"
}
installctftool(){
	git clone https://github.com/taviso/ctftool/ "$TOOLSFOLDER/$1/ctftool"
}

installresponder(){
	#git clone https://github.com/SpiderLabs/Responder.git "$TOOLSFOLDER/$1/responder" #original repo
	git clone https://github.com/lgandx/Responder "$TOOLSFOLDER/$1/responder"	   #forked maintained repo
	cd "$TOOLSFOLDER/$1/responder"
	#git submodule init && git submodule update --recursive
	#$SUDO python setup.py install
}
installmitm6(){
	git clone https://github.com/fox-it/mitm6.git "$TOOLSFOLDER/$1/mitm6"
	cd "$TOOLSFOLDER/$1/mitm6"
	pip3 install -r requirements.txt
	$SUDO python3 setup.py install
}
installpeas(){
	git clone https://github.com/mwrlabs/peas.git "$TOOLSFOLDER/$1/peas"
}

installimpacket(){
	git clone https://github.com/SecureAuthCorp/impacket.git "$TOOLSFOLDER/$1/impacket"
}
installcve-2019-1040-scanner(){
	git clone https://github.com/fox-it/cve-2019-1040-scanner.git "$TOOLSFOLDER/$1/cve-2019-1040-scanner"
}
installntlm-scanner(){
	git clone https://github.com/preempt/ntlm-scanner.git "$TOOLSFOLDER/$1/ntlm-scanner"
}
installaclpwn(){
	git clone https://github.com/fox-it/aclpwn.py.git "$TOOLSFOLDER/$1/aclpwn"
}
installldap-scanner(){
	git clone https://github.com/Romounet/ldap-scanner.git "$TOOLSFOLDER/$1/ldap-scanner"
}
installLdapRelayScan(){
	git clone https://github.com/zyn3rgy/LdapRelayScan "$TOOLSFOLDER/$1/LdapRelayScan"
}
installkrbrelayx(){
	git clone https://github.com/dirkjanm/krbrelayx.git "$TOOLSFOLDER/$1/krbrelayx"
}

installbettercap(){
	git clone https://github.com/bettercap/bettercap.git "$TOOLSFOLDER/$1/bettercap"
	$SUDO apt install golang-go libnetfilter-queue-dev libusb-1.0-0-dev libpcap-dev
	cd "$TOOLSFOLDER/$1/bettercap"
	$SUDO go build
}

installmitmf(){
	git clone https://github.com/byt3bl33d3r/MITMf.git "$TOOLSFOLDER/$1/mitmf"
}

#Bug d'install -> version release
installarachni(){
	git clone https://github.com/Arachni/arachni.git "$TOOLSFOLDER/$1/arachni"
	cd "$TOOLSFOLDER/$1/arachni"
	gem install bundler # Use $SUDO if you get permission errors.
	bundle install --without prof
	rake install
}
installsqlmap(){
	git clone https://github.com/sqlmapproject/sqlmap "$TOOLSFOLDER/$1/sqlmap-git"
}
installnikto(){
	git clone https://github.com/sullo/nikto "$TOOLSFOLDER/$1/nikto-git"
}
installbdfactory(){
	git clone https://github.com/secretsquirrel/the-backdoor-factory.git "$TOOLSFOLDER/$1/bdfactory"
}

installBashark(){
	git clone https://github.com/TheSecondSun/Bashark.git "$TOOLSFOLDER/$1/Bashark"
}

installdirb222(){
	cd "$TOOLSFOLDER/$1"
	wget http://sourceforge.net/projects/dirb/files/dirb/2.22/dirb222.tar.gz/download -O dirb222.tar.gz
	tar -xzf dirb222.tar.gz
	chmod +x dirb222
	cd "dirb222"
	for i in $(ls -d */); do chmod +x "$i"; done #use +X instead
	chmod +x configure
	./configure
	make
}
installdirbuster(){
	cd "$TOOLSFOLDER/$1/"
	wget http://sourceforge.net/projects/dirbuster/files/DirBuster%20%28jar%20%2B%20lists%29/1.0-RC1/DirBuster-1.0-RC1.zip/download -O DirBuster-1.0-RC1.zip
	unzip DirBuster-1.0-RC1.zip
}

installnuclei(){
	mkdir "$TOOLSFOLDER/$1/nuclei"
	go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
	ln -s $HOME/go/bin/nuclei "$TOOLSFOLDER/$1/nuclei/nuclei"
}
installhttprobe(){
	mkdir "$TOOLSFOLDER/$1/httprobe"
	go get -u github.com/tomnomnom/httprobe
	ln -s $HOME/go/bin/httprobe "$TOOLSFOLDER/$1/httprobe/httprobe"
}
installsubjack(){
	mkdir "$TOOLSFOLDER/$1/subjack"
	go get github.com/haccer/subjack
	ln -s $HOME/go/bin/httprobe "$TOOLSFOLDER/$1/subjack/subjack"
}


installtachyon(){
	git clone https://github.com/delvelabs/tachyon.git "$TOOLSFOLDER/$1/tachyon"
}

installsslyze(){
	#git clone https://github.com/iSECPartners/sslyze.git $TOOLSFOLDER/$1/sslyze
	git clone https://github.com/nabla-c0d3/sslyze.git "$TOOLSFOLDER/$1/sslyze"
	cd "$TOOLSFOLDER/$1/sslyze"
	$SUDO pip install -r requirements.txt --target ./lib
	python setup.py build
	#git clone https://github.com/nabla-c0d3/nassl.git nassl-sources
	#cd nassl-sources
	#wget http://zlib.net/zlib-1.2.8.tar.gz
	#tar xvfz  zlib-1.2.8.tar.gz
	#wget https://www.openssl.org/source/openssl-1.0.2g.tar.gz
	#tar xvfz  openssl-1.0.2g.tar.gz
	#python buildAll_unix.py
	#cp -R build/lib.linux-x86_64-2.7/nassl/ ../nassl
}

installsslyzeRGS(){
	git clone https://github.com/OPPIDA/sslyzeRGS.git "$TOOLSFOLDER/$1/sslyzeRGS"
	cd "$TOOLSFOLDER/$1/sslyzeRGS"
	$SUDO pip install -r requirements.txt --target ./lib
	#git clone https://github.com/nabla-c0d3/nassl.git nassl-sources
	#cd nassl-sources
	#wget http://zlib.net/zlib-1.2.8.tar.gz
	#tar xvfz  zlib-1.2.8.tar.gz
	#wget https://www.openssl.org/source/openssl-1.0.2g.tar.gz
	#tar xvfz  openssl-1.0.2g.tar.gz
	#python buildAll_unix.py
	#cp -R build/lib.linux-x86_64-2.7/nassl/ ../nassl
}

installnmap(){
	git clone https://github.com/nmap/nmap "$TOOLSFOLDER/$1/nmap"
	cd "$TOOLSFOLDER/$1/nmap"
	./configure
	make
}

installwireshark(){
	#please remove precompiled wireshark version first
	$SUDO apt install libgcrypt20-dev libbison-dev libssh-dev libpcap-dev libsystemd-dev  qtbase5-dev qttools5-dev qtmultimedia5-dev libqt5svg5-dev libkrb5-dev
	wget https://2.na.dl.wireshark.org/src/wireshark-3.0.0.tar.xz -O "$TOOLSFOLDER/$1/wireshark.tar.xz"
	cd "$TOOLSFOLDER/$1"
	tar -xvf wireshark.tar.xz
	rm wireshark.tar.xz
	#cd wireshark && mkdir build && cd build && cmake .. && make
}

installwpasycophant(){
	git clone https://github.com/sensepost/wpa_sycophant.git "$TOOLSFOLDER/$1/wpasycophant"
	cd "$TOOLSFOLDER/$1/wpasycophant"
	$SUDO apt install libnl-genl-3-200 libnl-genl-3-dev
	make -C src
	make -C wpa_supplicant #needs 
}
installhostapd-mana(){
	git clone https://github.com/sensepost/hostapd-mana.git "$TOOLSFOLDER/$1/hostapd-mana"
	cd "$TOOLSFOLDER/$1/hostapd-mana"
	make -C hostapd
}
installeaphammer(){
	git clone https://github.com/s0lst1c3/eaphammer.git  "$TOOLSFOLDER/$1/eaphammer"
	cd "$TOOLSFOLDER/$1/eaphammer"
	./kali-setup
}
installcap2hccapx(){
	mkdir "$TOOLSFOLDER/$1/cap2hccapx"
	cd "$TOOLSFOLDER/$1/cap2hccapx"
	wget https://raw.githubusercontent.com/hashcat/hashcat-utils/master/src/cap2hccapx.c
	gcc -o cap2hccapx cap2hccapx.c
}

installscapy-ssl_tls(){
	git clone https://github.com/tintinweb/scapy-ssl_tls "$TOOLSFOLDER/$1/scapy-ssl_tls"
}
installscapy(){
	git clone https://github.com/secdev/scapy.git "$TOOLSFOLDER/$1/scapy"
}

installstriptls(){
	git clone https://github.com/tintinweb/striptls.git "$TOOLSFOLDER/$1/striptls"
}

installdsniff(){
	git clone https://github.com/ggreer/dsniff "$TOOLSFOLDER/$1/dsniff"
}

installmitmproxy(){
	git clone https://github.com/mitmproxy/mitmproxy.git "$TOOLSFOLDER/$1/mitmproxy"
}

installpyrdp(){
	git clone https://github.com/GoSecure/pyrdp.git "$TOOLSFOLDER/$1/pyrdp"
	$SUDO apt install libdbus-1-dev libdbus-glib-1-dev
	$SUDO pip3 install -U -e .
	cd "$TOOLSFOLDER/$1/pyrdp"
	python3 setup.py build
	$SUDO python setup.py install
}

installkillerbee(){
	#git clone https://github.com/riverloopsec/killerbee.git "$TOOLSFOLDER/$1/killerbee"
	mkdir "$TOOLSFOLDER/$1/killerbee"
	wget https://github.com/riverloopsec/killerbee/archive/refs/tags/3.0.0-beta.2.tar.gz -O "$TOOLSFOLDER/$1/killerbee/killerbee-3.0.tgz"
	tar -xzvf "$TOOLSFOLDER/$1/killerbee/killerbee-3.0.tgz"
	cd "$TOOLSFOLDER/$1/killerbee/killerbee-3.0.0-beta.2"
	$SUDO apt install libgcrypt-dev python3-usb
	$SUDO python3 setup.py install
}

installGWTtoolset(){
	git clone https://github.com/GDSSecurity/GWT-Penetration-Testing-Toolset.git "$TOOLSFOLDER/$1/GWTtoolset"
}

installwabt(){
	git clone https://github.com/WebAssembly/wabt.git "$TOOLSFOLDER/$1/wabt"
}

installblindelephant(){
	git clone https://github.com/lokifer/BlindElephant.git "$TOOLSFOLDER/$1/blindelephant"
}

installgdbpeda(){
	git clone https://github.com/longld/peda.git "$TOOLSFOLDER/$1/gdbpeda"
	echo "source $TOOLSFOLDER/$1/gdbpeda/peda.py" >> ~/.gdbinit
}
installcwe_checker(){
	git clone https://github.com/fkie-cad/cwe_checker.git "$TOOLSFOLDER/$1/cwe_checker"
}

installpwndbg(){
	git clone https://github.com/pwndbg/pwndbg "$TOOLSFOLDER/$1/pwndbg"
	cd "$TOOLSFOLDER/$1/pwndbg"
	./setup.sh
}

installpaimei(){
	git clone https://github.com/OpenRCE/paimei.git "$TOOLSFOLDER/$1/paimei"
}

installgdbexploitable(){
	git clone https://github.com/jfoote/exploitable.git "$TOOLSFOLDER/$1/gdbexploitable"
}

installradare2(){
	git clone https://github.com/radare/radare2.git "$TOOLSFOLDER/$1/radare2"
}

installexploit-database(){
	#This is searchsploit
	git clone https://github.com/offensive-security/exploit-database.git "$TOOLSFOLDER/$1/exploit-database"
}

installcarnalMSFexploits(){
	git clone https://github.com/carnal0wnage/Metasploit-Code.git "$TOOLSFOLDER/$1/carnalMSFexploits"
}

installpompem(){
	git clone https://github.com/rfunix/Pompem.git "$TOOLSFOLDER/$1/pompem"
}

installms017(){
	git clone https://github.com/RiskSense-Ops/MS17-010.git "$TOOLSFOLDER/$1/ms017"
}

installnrpe(){
	git clone https://github.com/NagiosEnterprises/nrpe "$TOOLSFOLDER/$1/nrpe"
	cd "$TOOLSFOLDER/$1/nrpe"
	./configure
	make check_nrpe
}

installSn1per(){
	git clone https://github.com/1N3/Sn1per.git "$TOOLSFOLDER/$1/Sn1per"
	cd "$TOOLSFOLDER/$1/Sn1per"
	$SUDO ./install.sh
	$SUDO ln -s "$TOOLSFOLDER/$1/Sn1per/sniper" /usr/bin/sniper
	shodan init qrlLdNgKLrAcc26D4oHn72yjVlCNulbP
}


installgolismero(){
	git clone https://github.com/golismero/golismero.git "$TOOLSFOLDER/$1/golismero"
	cd "$TOOLSFOLDER/$1/golismero"
	$SUDO pip install -r requirements.txt
	$SUDO pip install -r requirements_unix.txt
	$SUDO ln -s "$TOOLSFOLDER/$1/golismero/golismero.py" /usr/bin/golismero
}


installmallory(){
    hg clone https://bitbucket.org/IntrepidusGroup/mallory "$TOOLSFOLDER/$1/mallory"
    $SUDO pip install pynetfilter_conntrack
}

installxsser(){
	git clone https://github.com/epsylon/xsser-public "$TOOLSFOLDER/$1/xsser"
}

installysoserial(){
	git clone https://github.com/pwntester/ysoserial.net "$TOOLSFOLDER/$1/ysoserial"
	wget https://jitpack.io/com/github/frohoff/ysoserial/master-SNAPSHOT/ysoserial-master-SNAPSHOT.jar -O "$TOOLSFOLDER/$1/ysoserial/ysoserial.jar"
}

installgitrob(){
	git clone https://github.com/michenriksen/gitrob "$TOOLSFOLDER/$1/gitrob"
}

installenum4linux(){
	git clone https://github.com/portcullislabs/enum4linux "$TOOLSFOLDER/$1/enum4linux"
}

installcapstone(){
	git clone https://github.com/aquynh/capstone.git "$TOOLSFOLDER/$1/capstone"
}

installveilFramework(){
	git clone https://github.com/Veil-Framework/Veil.git "$TOOLSFOLDER/$1/veilFramework"
	cd "$TOOLSFOLDER/$1/veilFramework"
	chmod +x ./Install.sh
	./Install.sh -c
}

installimmdbgtools(){
	mkdir "$TOOLSFOLDER/$1/immdbgtools"
	git clone https://github.com/corelan/mona "$TOOLSFOLDER/$1/immdbgtools/mona"
}
installImHex(){
	git clone https://github.com/WerWolv/ImHex.git "$TOOLSFOLDER/$1/ImHex"
}

installsjet(){
	git clone https://github.com/siberas/sjet.git "$TOOLSFOLDER/$1/sjet"
}

installsulley(){
	git clone https://github.com/OpenRCE/sulley.git "$TOOLSFOLDER/$1/sulley"
}

installboofuzz(){
	git clone https://github.com/jtpereyda/boofuzz.git "$TOOLSFOLDER/$1/boofuzz"
	pip3 install boofuzz
}

#TODO: integrate zzuf?
#pip install pyzzuf

installFuzzLabs(){
	git clone https://github.com/keymandll/FuzzLabs.git "$TOOLSFOLDER/$1/FuzzLabs"
	# Little issue with python-apt ...
	$SUDO "$TOOLSFOLDER/$1/FuzzLabs/engine/setup.sh"
	$SUDO "$TOOLSFOLDER/$1/FuzzLabs/webserver/setup.sh"
}


installafl(){
    wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz -O "$TOOLSFOLDER/$1/afl-latest.tgz"
    cd "$TOOLSFOLDER/$1/"
    tar -xzvf afl-latest.tgz
}

installisic(){
	$SUDO apt-get install libnet1-dev
	git clone https://github.com/dropletzhu/isic-fix.git "$TOOLSFOLDER/$1/isic"
	cd "$TOOLSFOLDER/$1/isic"
	./configure
	make
}

installmanticore(){
	#git clone https://github.com/trailofbits/manticore $TOOLSFOLDER/$1/manticore
	mkvirtualenv "$TOOLSFOLDER/$1/manticore"
	source "$TOOLSFOLDER/$1/manticore/bin/activate"
	$SUDO pip2 install manticore
	deactivate
}

installradamsa(){
    git clone https://gitlab.com/akihe/radamsa "$TOOLSFOLDER/$1/radamsa"
    cd "$TOOLSFOLDER/$1/radamsa"
    #make
}
installe9afl(){
	git clone https://github.com/GJDuck/e9afl.git "$TOOLSFOLDER/$1/e9afl"
}

installwpscan(){
	# $SUDO apt-get install libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev
	git clone https://github.com/wpscanteam/wpscan.git "$TOOLSFOLDER/$1/wpscan"
	cd "$TOOLSFOLDER/$1/wpscan"
	$SUDO gem install bundler && bundle install --without test
}
installurlExtractor(){
	git clone https://github.com/jobertabma/relative-url-extractor.git "$TOOLSFOLDER/$1/urlExtractor"
}

installvbscan(){
	git clone https://github.com/rezasp/vbscan "$TOOLSFOLDER/$1/vbscan"
}

installsparty(){
	git clone https://github.com/alias1/sparty "$TOOLSFOLDER/$1/sparty"
}

installdroopescan(){
	git clone https://github.com/droope/droopescan.git "$TOOLSFOLDER/$1/droopescan"
	cd "$TOOLSFOLDER/$1/droopescan"
	pip install -r requirements.txt
}

installsvnExtractor(){
	git clone https://github.com/anantshri/svn-extractor "$TOOLSFOLDER/$1/svnExtractor"

}

installJavaSerialKillerPlugin(){
	git clone https://github.com/NetSPI/JavaSeriaKiller "$TOOLSFOLDER/$1/JavaSerialKillerPlugin"
}

installwfuzz(){
	git clone https://github.com/xmendez/wfuzz "$TOOLSFOLDER/$1/wfuzz"
}

installaquatone(){
	$SUDO apt install chromium-bsu
	mkdir -p "$TOOLSFOLDER/$1/aquatone"
	wget https://github.com/michenriksen/aquatone/releases/download/v1.4.3/aquatone_linux_amd64_1.4.3.zip -O "$TOOLSFOLDER/$1/aquatone/aquatone_linux_amd64_1.4.3.zip"
	cd "$TOOLSFOLDER/$1/aquatone/"
	unzip aquatone_linux_amd64_1.4.3.zip
}

installblindElephant(){
	git clone https://github.com/lokifer/BlindElephant "$TOOLSFOLDER/$1/blindElephant"
}

installdefaceJSF(){
	# JSF Testing tool
	git clone https://github.com/SpiderLabs/deface.git "$TOOLSFOLDER/$1/defaceJSF"
	cd "$TOOLSFOLDER/$1/defaceJSF"
	ant -buildfile build.xml
}

installdpe(){
	# DEFAULT CREDENTIALS DICTIONNARY
	cd "$TOOLSFOLDER/$1"
	mkdir dpe
	cd "dpe"
	wget http://www.toolswatch.org/dpe/dpeparser.py
	chmod +x dpeparser.py
	#./dpeparser.py --update
}

installPowerSploit(){
	git clone https://github.com/PowerShellMafia/PowerSploit.git "$TOOLSFOLDER/$1/PowerSploit"
}


installdnSpy(){
	git clone https://github.com/0xd4d/dnSpy.git "$TOOLSFOLDER/$1/dnSpy"
}

installangr(){
	mkvirtualenv "$TOOLSFOLDER/$1/angr"
	source "$TOOLSFOLDER/$1/angr/bin/activate"
	pip install angr
	deactivate
}

installangrcli(){
	git clone https://github.com/fmagin/angr-cli.git "$TOOLSFOLDER/$1/angrcli"
}

installropgadget(){
	git clone https://github.com/JonathanSalwan/ROPgadget.git "$TOOLSFOLDER/$1/ropgadget"
}

installBlueKeep(){
	git clone https://github.com/Ekultek/BlueKeep "$TOOLSFOLDER/$1/BlueKeep"
}

installzerologon-dirkjanm(){
	git clone https://github.com/dirkjanm/CVE-2020-1472.git "$TOOLSFOLDER/$1/zerologon-dirkjanm"
}
installpywsus(){
	git clone https://github.com/GoSecure/pywsus.git "$TOOLSFOLDER/$1/pywsus"
}
installItWasAllADream(){
	git clone https://github.com/byt3bl33d3r/ItWasAllADream.git "$TOOLSFOLDER/$1/ItWasAllADream"
}
installprintnightmare-LPE-powershell(){
	git clone https://github.com/calebstewart/CVE-2021-1675.git "$TOOLSFOLDER/$1/printnightmare-LPE-powershell"
}
installproxyshell(){
	git clone https://github.com/horizon3ai/proxyshell.git "$TOOLSFOLDER/$1/proxyshell"
}

installcrowbar(){
	git clone https://github.com/galkan/crowbar.git "$TOOLSFOLDER/$1/crowbar"
}

installnishang(){
	git clone https://github.com/samratashok/nishang.git "$TOOLSFOLDER/$1/nishang"
}

installkoadic(){
	git clone https://github.com/zerosum0x0/koadic.git "$TOOLSFOLDER/$1/koadic"
}

installsmbmap(){
	git clone https://github.com/ShawnDEvans/smbmap.git "$TOOLSFOLDER/$1/smbmap"
}


installSMBCrunch(){
	git clone https://github.com/Raikia/SMBCrunch "$TOOLSFOLDER/$1/SMBCrunch"
}

installMakeMeEnterpriseAdmin(){
	git clone https://github.com/vletoux/MakeMeEnterpriseAdmin.git "$TOOLSFOLDER/$1/MakeMeEnterpriseAdmin"
}

installpowershellempire(){
	git clone https://github.com/EmpireProject/Empire.git "$TOOLSFOLDER/$1/powershellempire"
}

installruler(){
	git clone https://github.com/sensepost/ruler "$TOOLSFOLDER/$1/ruler"
}

installsprayingtoolkit(){
	git clone https://github.com/byt3bl33d3r/SprayingToolkit "$TOOLSFOLDER/$1/sprayingtoolkit"
}

installoffice365userenum(){
	mkdir "$TOOLSFOLDER/$1/office365userenum"
	wget https://bitbucket.org/grimhacker/office365userenum/get/85192ac47522.zip -O "$TOOLSFOLDER/$1/office365userenum/office365userenum.zip"
	cd "$TOOLSFOLDER/$1/office365userenum"
	unzip office365userenum.zip
}

installUhOh365(){
	git clone https://github.com/Raikia/UhOh365.git "$TOOLSFOLDER/$1/UhOh365"
}
installpatator(){
	git clone https://github.com/lanjelot/patator.git "$TOOLSFOLDER/$1/patator"
}

installpytbull(){
	#wget https://downloads.sourceforge.net/project/pytbull/pytbull-2.1.tar.bz2 -O $TOOLSFOLDER/$1/pytbull-2.1.tar.bz2
	#cd $TOOLSFOLDER/$1/
	#tar -xvf pytbull-2.1.tar.bz2
	hg clone http://pytbull.hg.sourceforge.net:8000/hgroot/pytbull/pytbull "$TOOLSFOLDER/$1/pytbull/"
}

installfragrouter(){
	git clone git://git.kali.org/packages/fragrouter.git "$TOOLSFOLDER/$1/fragrouter/"
	cd "$TOOLSFOLDER/$1/fragrouter/"
	./configure
	make
}

installfrogger(){
	git clone https://github.com/nccgroup/vlan-hopping---frogger.git "$TOOLSFOLDER/$1/frogger"
}

installsniffjoke(){
	git clone https://github.com/vecna/sniffjoke.git "$TOOLSFOLDER/$1/sniffjoke/"
	cd "$TOOLSFOLDER/$1/sniffjoke/"
	mkdir build
	cd build
	cmake ..
	make 
}

installncrack(){
	wget https://nmap.org/ncrack/dist/ncrack-0.4ALPHA.tar.gz -O "$TOOLSFOLDER/$1/ncrack-0.4ALPHA.tar.gz"
	cd "$TOOLSFOLDER/$1/"
	mkdir ncrack
	tar -xzvf ncrack-0.4ALPHA.tar.gz -C ./ncrack/
	cd ./ncrack/ncrack-0.4ALPHA/
	./configure
	make
}

installDET(){
	git clone https://github.com/sensepost/DET.git "$TOOLSFOLDER/$1/DET"
}

#
## Audit de Code
#

installlapse(){
	#Eclipse doit être installé d'abord!
	mkdir "$TOOLSFOLDER/$1/lapse"
	wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/lapse-plus/LapsePlusTutorial.pdf -O "$TOOLSFOLDER/$1/lapse/LapsePlusTutorial.pdf"
	wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/lapse-plus/LapsePlus_2.8.1.jar -O "$TOOLSFOLDER/$1/lapse/LapsePlus_2.8.1.jar"
	wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/lapse-plus/LapsePlusConsola_2.8.0.zip -O "$TOOLSFOLDER/$1/lapse/LapsePlusConsola_2.8.0.zip"
	wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/lapse-plus/LapsePlusPlugin_2.8.0.jar -O "$TOOLSFOLDER/$1/lapse/LapsePlusPlugin_2.8.0.jar"
	$SUDO cp "$TOOLSFOLDER/$1/lapse/LapsePlusPlugin_2.8.0.jar /usr/lib/eclipse/plugins/"

}

installmilk(){
	wget http://downloads.sf.net/milk/milk-0.25.zip?use_mirror=heanet -O "$TOOLSFOLDER/$1/milk-0.25.zip"
	cd "$TOOLSFOLDER/$1/"
	unzip milk-0.25.zip
}

installRATS(){
	git clone https://github.com/andrew-d/rough-auditing-tool-for-security.git "$TOOLSFOLDER/$1/RATS"
}

installbrakeman(){
	git clone https://github.com/presidentbeef/brakeman "$TOOLSFOLDER/$1/brakeman"
}

installpylama(){
	git clone https://github.com/klen/pylama.git "$TOOLSFOLDER/$1/pylama"
}

installeclipse(){
	#Recette utile car la version des depots ubuntu est tres ancienne (3.8) pour une raison quelconque
	wget "https://www.eclipse.org/downloads/download.php?file=/oomph/epp/mars/R2/eclipse-inst-linux64.tar.gz&mirror_id=1208" -O "~/eclipse-inst-linux64.tar.gz"
	cd "$TOOLSFOLDER/$1"
	tar -xzvf eclipse-inst-linux64.tar.gz
	cd eclipse-installer
	$SUDO mkdir "$BIGAPPS/eclipse"
	chown "$identity:$identity" "$BIGAPPS/eclipse"
	./eclipse-inst
}

installdependencycheck(){
	#see http://jeremylong.github.io/DependencyCheck/dependency-check-cli/index.html for updates
	wget h"ttp://dl.bintray.com/jeremy-long/owasp/dependency-check-1.3.5-release.zip" -O "$TOOLSFOLDER/$1/dependency-check-1.3.5-release.zip"
	cd "$TOOLSFOLDER/$1/"
	unzip dependency-check-1.3.5-release.zip
	mv dependency-check dependencycheck
}


installtrinity(){
    git clone https://github.com/kernelslacker/trinity.git "$TOOLSFOLDER/$1/trinity"
}

installltp(){
    git clone https://github.com/linux-test-project/ltp "$TOOLSFOLDER/$1/ltp"
}

installkernelfuzzing(){
    git clone https://github.com/oracle/kernel-fuzzing.git "$TOOLSFOLDER/$1/kernelfuzzing"
}

installsyzkaller(){
    git clone https://github.com/google/syzkaller.git "$TOOLSFOLDER/$1/syzkaller"
}


installkfetch-toolkit(){
    git clone https://github.com/j00ru/kfetch-toolkit.git "$TOOLSFOLDER/$1/kfetch-toolkit"
}

installiofuzz(){
    git clone https://github.com/debasishm89/iofuzz.git "$TOOLSFOLDER/$1/iofuzz"
}

installcrashme(){
    wget https://crashme.codeplex.com/downloads/get/842450 -O "$TOOLSFOLDER/$1/crashme-2.7.tgz"
    cd "$TOOLSFOLDER/$1/"
    tar xvf crashme-2.7.tgz
}

installbinwalk(){
    git clone https://github.com/devttys0/binwalk.git "$TOOLSFOLDER/$1/binwalk"
    cd "$TOOLSFOLDER/$1/binwalk"
    $SUDO ./deps.sh
    $SUDO python setup.py install
}


installrekall(){
    virtualenv /tmp/Test
    source /tmp/Test/bin/activate
    git clone https://github.com/google/rekall.git "$TOOLSFOLDER/$1/rekall"
    #pip install --editable ./rekall-core
    #pip install --editable .
}

installvolatility(){
    git clone https://github.com/volatilityfoundation/volatility.git "$TOOLSFOLDER/$1/volatility"
}

installvulners(){
    git clone https://github.com/videns/vulners-scanner "$TOOLSFOLDER/$1/vulners"
}

installlinenum(){
    git clone https://github.com/rebootuser/LinEnum.git "$TOOLSFOLDER/$1/linenum"
}

installlinuxprivchecker(){
    mkdir "$TOOLSFOLDER/$1/linuxprivchecker"
    wget https://www.securitysift.com/download/linuxprivchecker.py -O "$TOOLSFOLDER/$1/linuxprivchecker/linuxprivchecker.py"
}

installspectremeltdownchecker(){
    git clone https://github.com/speed47/spectre-meltdown-checker.git "$TOOLSFOLDER/$1/spectremeltdownchecker"
}

installlinux-exploit-suggester(){
    git clone  https://github.com/mzet-/linux-exploit-suggester.git "$TOOLSFOLDER/$1/linux-exploit-suggester"
}
installunix-privesc-check(){
    wget http://pentestmonkey.net/tools/unix-privesc-check/unix-privesc-check-1.4.tar.gz -O "$TOOLSFOLDER/$1/unix-privesc-check-1.4.tar.gz"
    cd "$TOOLSFOLDER/$1"
    tar -xzvf unix-privesc-check-1.4.tar.gz
}

installwindowsEnum(){
    git clone https://github.com/azmatt/windowsEnum.git "$TOOLSFOLDER/$1/windowsEnum"
}

installwindows-privesc-check(){
    git clone https://github.com/pentestmonkey/windows-privesc-check.git "$TOOLSFOLDER/$1/windows-privesc-check"
}
installwindows-exploit-suggester(){
    git clone https://github.com/GDSSecurity/Windows-Exploit-Suggester.git "$TOOLSFOLDER/$1/windows-exploit-suggester"
    cd "$TOOLSFOLDER/$1/windows-exploit-suggester"
    python windows-exploit-suggester.py --update
}
installWSuspicious(){
	git clone https://github.com/GoSecure/WSuspicious.git "$TOOLSFOLDER/$1/WSuspicious"
}
installWinPwn(){
	git clone https://github.com/S3cur3Th1sSh1t/WinPwn.git "$TOOLSFOLDER/$1/WinPwn"
}
installJAWS(){
	git clone https://github.com/411Hall/JAWS.git "$TOOLSFOLDER/$1/JAWS"
}

installpowersploit(){
    git clone https://github.com/pentestmonkey/windows-privesc-check.git "$TOOLSFOLDER/$1/powersploit"
    ln -s "$TOOLSFOLDER/$1/powersploit/Privesc/" "$TOOLSFOLDER/windows-privesc/PowerUp"
}

installobjection(){
    git clone https://github.com/sensepost/objection.git "$TOOLSFOLDER/$1/objection"
    pip3 install objection
}


#
## Décompilateurs .NET
#

#installreflector(){
#}
#installilspy(){
#}

#
## Non Standard Install Receipes:
#

installsublime(){
	if [[ $(whereis subl | cut -d ':' -f 2) == "" ]]; then 
		echo "Sublime text not found"
		echo "Installing Sublime Text editor 3:"
		do_installsublime3
		echo ""
		echo "Installation of sublime text done"
		echo ""
	else 
		echo "Sublime text already installed"
		echo ""
	fi
}

do_installsublime3(){
	#wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb -O /tmp/sublime-text_build-3083_amd64.deb
	#$SUDO dpkg -i /tmp/sublime-text_build-3083_amd64.deb
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | $SUDO apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | $SUDO tee /etc/apt/sources.list.d/sublime-text.list
	$SUDO apt-get update
	$SUDO apt-get install sublime-text
}

installpycharm(){
	for PYCHARMDIR in "/opt/pycharm"*; do
		if [ ! -d "$PYCHARMDIR" ]; then
			echo "Pycharm not found"
			echo "Installing pycharm:"
			do_installpycharm
			echo ""
			echo "Installation of pycharm done"
			echo ""
		else 
			echo "Previous installation of pycharm detected"
			echo ""
		fi
		break
	done
}
do_installpycharm(){
	wget https://download.jetbrains.com/python/pycharm-community-2016.1.2.tar.gz -O /tmp/pycharm.tar.gz
	$SUDO mkdir "$BIGAPPS/pycharm"
	$SUDO chown "$identity:$identity" "$BIGAPPS/pycharm"
	tar -xzvf /tmp/pycharm.tar.gz -C /opt/pycharm/
	cd "$BIGAPPS/pycharm"
}

installnetworkminer(){
	$SUDO apt install mono-runtime libmono-system-windows-forms4.0-cil libmono-system-web4.0-cil libmono-system-net4.0-cil libmono-system-runtime-serialization4.0-cil libmono-system-xml-linq4.0-cil
	for NTMINERDIR in "/opt/NetworkMiner"*; do
		if [ ! -d "$NTMINERDIR" ]; then
			echo "Network Miner not found"
			echo "Installing Network Miner:"
			do_installNetworkMiner
			echo ""
			echo "Installation of Network Miner done"
			echo ""
		else 
			echo "Previous installation of NetworkMiner detected"
			echo ""
		fi
		break
	done
}

do_installNetworkMiner(){
    #Faut il vraiment le laisser dans /opt/ ?
	wget sf.net/projects/networkminer/files/latest -O /tmp/nm.zip
	$SUDO unzip /tmp/nm.zip -d /opt/
	cd /opt/NetworkMiner*
	$SUDO chmod +x NetworkMiner.exe
	$SUDO chmod -R go+w AssembledFiles/
	$SUDO chmod -R go+w Captures/
}

installEtherpad(){
	if [ ! -d "/opt/etherpad-git" ]; then
		echo "Etherpad directory not found"
		echo "Installing etherpad:"
		do_installEtherpad
		echo ""
	else
		echo "Previous installation of Etherpad detected"
		echo ""
	fi
}

do_installEtherpad(){
	curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
	$SUDO apt-get install -y nodejs
	git clone --branch master https://github.com/ether/etherpad-lite.git /opt/etherpad-git
	npm install npm@latest -g
}

installjython(){
	if [ ! -d "/opt/jython2.7.0/" ]; then
		echo "Jython directory not found"
		echo "Installing jython:"
		do_installJython
		echo ""
	else
		echo "Previous installation of jython detected"
		echo ""
	fi
}
do_installJython(){
	wget 'http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.0/jython-installer-2.7.0.jar' -O '/tmp/jython-installer-2.7.0.jar'
	java -jar /tmp/jython-installer-2.7.0.jar
	echo "export JYTHON_HOME=/opt/jython2.7.0/
export PATH=$JYTHON_HOME/bin:$PATH" >> "$identity/.bashrc"
}

installdbeaver(){
	if [ ! -d "/opt/dbeaver/" ]; then
		echo "Dbeaver directory not found"
		echo "Installing dbeaver:"
		do_installDbeaver
		echo ""
	else
		echo "Previous installation of dbeaver detected"
		echo ""
	fi
}
do_installDbeaver(){
	mkdir "/opt/dbeaver"
	wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -O "/opt/dbeaver/dbeaver-ce_latest_amd64.deb"
	dpkg -i "/opt/dbeaver/dbeaver-ce_latest_amd64.deb"
}

installSET(){
	git clone https://github.com/trustedsec/social-engineer-toolkit.git "$TOOLSFOLDER/$1/SET"
}

installchsh(){
	git clone https://github.com/chubin/cheat.sh.git "$TOOLSFOLDER/$1/chsh"
}
installmyCheatSheets(){
	git clone https://github/com/Rcarnus/myCheatSheets.git "$TOOLSFOLDER/$1/myCheatSheets"
}

installols(){
	#git clone https://github.com/jawi/ols.git "$TOOLSFOLDER/$1/ols"
	wget https://www.lxtreme.nl/ols/ols-0.9.7.2-full.tar.gz -O "$TOOLSFOLDER/$1/ols-0.9.7.2-full.tar.gz"
	cd "$TOOLSFOLDER/$1"
	tar -xzvf "ols-0.9.7.2-full.tar.gz"
	rm "ols-0.9.7.2-full.tar.gz"
}
installpcileech(){
	git clone https://github.com/ufrisk/pcileech.git "$TOOLSFOLDER/$1/pcileech"
	wget https://github.com/ufrisk/pcileech/releases/download/v4.12/PCILeech_files_and_binaries_v4.12.1-linux_x64-20211003.tar.gz -O "$TOOLSFOLDER/$1/pcileech/pcileech_files_and_binaries.tar.gz"
	cd "$TOOLSFOLDER/$1/pcileech"
	tar -xzvf pcileech_files_and_binaries.tar.gz 
}
installflashrom(){
	git clone https://github.com/flashrom/flashrom.git "$TOOLSFOLDER/$1/flashrom"
	$SUDO apt install libpci-dev zlib1g-dev libftdi-dev libusb-dev build-essential
	cd "$TOOLSFOLDER/$1/flashrom"
	make
	make install
}
installbuspirate(){
	mkdir "$TOOLSFOLDER/$1/buspirate"
	wget https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/dangerous-prototypes-open-hardware/source-archive.zip  -O "$TOOLSFOLDER/$1/buspirate/buspirate.zip"
	cd "$TOOLSFOLDER/$1/buspirate"
	unzip buspirate.zip
}
installlpc_sniffer_tpm(){
	git clone https://github.com/denandz/lpc_sniffer_tpm.git "$TOOLSFOLDER/$1/lpc_sniffer_tpm"
}
installfirmware-mod-kit(){
	git clone https://github.com/rampageX/firmware-mod-kit.git "$TOOLSFOLDER/$1/firmware-mod-kit"
}
installgrub-unlzma(){
	git clone https://github.com/msuhanov/grub-unlzma.git "$TOOLSFOLDER/$1/grub-unlzma"
}
installuboot-mdb-dump(){
	git clone https://github.com/gmbnomis/uboot-mdb-dump.git "$TOOLSFOLDER/$1/uboot-mdb-dump"
}
installarm_now(){
	git clone https://github.com/nongiach/arm_now.git "$TOOLSFOLDER/$1/arm_now"
}
installkillerbee(){
	git clone https://github.com/riverloopsec/killerbee.git "$TOOLSFOLDER/$1/killerbee"
}


#######################
####### Oppida ########
#######################
#installtool sslyzeRGS ssl


#######################
###### GoSecure #######
#######################


#######################
## Available in Kali ##
#######################
$SUDO apt install afl exploitdb capstone-tool ropper kerberoast mimikatz aircrack-ng jxplorer testssl.sh
#installtool sslyze ssl
#installtool dnsenum recon
#installtool dnsrecon recon
#installtool nmap reseau
#installtool aircrack reseau 		#cracker wifi
#installtool wireshark reseau
#installtool wpasycophant reseau/wifi
#installtool hostapd-mana reseau/wifi
#installtool eaphammer reseau/wifi
installtool cap2hccapx reseau/wifi
#installtool hcxdumptool reseau/wifi
#installtool hcxtools reseau/wifi
#installtool nikto web/fingerprint
#installtool arachni web/scanner 	#probleme de dependances avec le git
#installtool sqlmap web/sql
#installtool dirb222 web		#BF path web
#installtool theHarvester web/fingerprint	#Open web ressources harvester
#installtool wfuzz web/fingerprint	#Enumeration de dirs web
installtool aquatone web/fingerprint	#Fingerprint web interfaces
#installtool smbmap windows
#installtool enum4linux windows  	#enumeration domain, user, null session RID cycling, OS info
installtool responder windows		#WPAD spoof exploit
installtool peas windows		#Active sync cmd line tool
installtool impacket windows		
installtool aclpwn windows
installtool ldap-scanner windows
installtool LdapRelayScan windows
installtool cve-2019-1040-scanner exploit
installtool ntlm-scanner exploit
installtool krbrelayx windows		
#installtool bettercap reseau		
installtool mitmf reseau
#installtool wpscan web/fingerprint     #scanner WordPress CMS
installtool urlExtractor web		#extraction of url into js
#installtool volatility forensics       #framework d'inspection de la memoire. Probablement utile dans d'autres cas de figure que le forensics
#installtool rekall forensics		#framework d'inspection de la memoire. Probablement utile dans d'autres cas de figure que le forensics
#installtool afl fuzzer			#American fuzzy loop: fuzzing genetique par instrumentation de code (une reference)
#installtool binwalk reverse
installtool nishang windows		#post exploit du style powersploit
#installtool exploit-database exploit
installtool carnalMSFexploits exploit
installtool PowerSploit windows	#set de tools PowerShell d'exploitation windows
#installtool fragrouter reseau		#fragmentation IP
#installtool trinity kernel		#syscall fuzzer
#installtool pompem exploit
#installtool capstone reverse
#installtool ncrack cracker		#fast cracker reseau
#installtool SET social-engineering      #toolkit de SE qui semble assez riche
installtool PCredz reseau/analyse    	#Analyse CB/NTML etc. dans PCAP
#installtool mimikatz windows
installtool rdp-check-sec windows
installtool wabt reverse
#installtool apktool mobile
installtool crowbar exploit
#installtool golismero recon
installsublime


#######################
######  Reseau  #######
#######################
installtool pytbull reseau   		#bypass IDS
installtool frogger reseau		#VLAN hopping facility tool
#installtool sniffjoke reseau
installtool DET reseau  		#Tool anti DLP (data leak protection)
installtool scapy reseau
installtool scapy-ssl_tls reseau
installtool striptls reseau
installtool dsniff reseau 		#set de tools pour attaques reseau notamment overflow de mac : switch -> hub
installtool mitmproxy reseau 		#outil de manipulation de paquets (http) en mode proxy mitm (en command line)
installtool pyrdp reseau


#######################
######  Wireless ######
#######################
installtool killerbee wireless


#######################
###  Kernel Linux  ####
#######################

installtool ltp kernel  		#testing generaliste de Linux
installtool kernelfuzzing kernel 	#portage kernel de afl
installtool syzkaller kernel 		#Multi-os unsuppervised syscall fuzzing
#installtool crashme kernel  		#Lien non automatisable
installtool iofuzz kernel		#Fuzzing d'IO
installtool kfetch-toolkit kernel  	#debug kernel
#installtool ktsan kernel  		#KernelThreadSanitizer (warning before cloning: linux with patches)
#installtool kmsan kernel  		#KernelMemorySanitizer (warning before cloning: linux with patches)

#######################
#######  Recon  #######
#######################

installtool amass recon
installtool subfinder recon
installtool ikeprobe recon
installtool nuclei web
installtool gau web
installtool subjack recon
installtool httprobe recon
installtool cloud_enum recon
installtool gitleaks recon

#######################
####  Windows/AD  #####
#######################

installtool ntlmsspparse windows	#Analyse NTLMSSP dans PCAP. pcredz does that already ?
installtool ntlmdecoder windows
#installtool CredCrack windows  	#PSploit better...
installtool mitm6 windows		#spoof dhcp6 requests on the network
#installtool pykek windows		#Original github repo removed, see the following one:
#install RIDENUM windows		#enum4linux semble faire pareil ou mieux
#install winexe windows			#execution de commande au travers de SAMBA (remplacé par crackmapexec)
installtool koadic windows		#pivoting tool for windows
installtool SMBCrunch windows
installtool MakeMeEnterpriseAdmin windows #Escalate from domain admin to enterprise admin
installtool powershellempire windows
installtool ruler windows		#WPAD spoof exploit
installtool sprayingtoolkit exploit
installtool office365userenum exploit
installtool UhOh365 exploit
installtool patator exploit
#installtool crackmapexec windows
installtool privexchange windows
installtool bloodhound-python windows
installtool BloodHound windows
installtool goddi windows
installtool PetitPotam windows
installtool ctftool exploit
installtool kerbrute windows
installtool DachshundAD windows
installtool PKINITtools windows
installtool KrbRelayUp windows

#######################
######  Mobile  #######
#######################

installtool objection mobile

#######################
#######  Web  #########
#######################

installtool vbscan web/fingerprint        #scanner vBulletin CMS
installtool sparty web/fingerprint        #scanner SharePoint CMS
#install droopescan web/fingerprint    #scanner Drupal/WP/SilverStripe _ Probleme de droit d'accès au repo git
installtool svnExtractor web/fingerprint  #extracteur de fichier a partir du .svn
#install JavaSerialKillerPlugin web/scanner/burp  #exploit Java serialization, plugin burp _ Probleme de droit d'accès au repo git
installtool blindelephant web/fingerprint	
#install dirbuster web
installtool tachyon web
#install GWTtoolset web
#install xsser web
#install Sn1per web/fingerprint
installtool ysoserial exploit
installtool gitrob web

#######################
###### Forensics ######
#######################

#######################
######  Exploit #######
#######################

installtool gdbpeda reverse
installtool cwe_checker reverse
installtool pwndbg reverse
installtool paimei reverse
installtool bdfactory exploit  #patch exe avec shellcode arbitraire
installtool Bashark exploit	#post-exploit un pure bash
#install veilFramework exploit #Trop lourd et necessite deja MetasploiT
installtool immdbgtools exploit
installtool ImHex exploit
installtool ms017 exploit
installtool boofuzz fuzzer
installtool radamsa fuzzer
installtool e9afl fuzzer
installtool sjet exploit

#FIXME: issue with mkvirtualenv (from virtualenvwrapper package)
#installtool angr exploit		#Framework d'analyse binaire concolique
#installtool manticore fuzzer

installtool isic fuzzer
#install FuzzLabs fuzzer
#install defaceJSF web/scanner
installtool dpe dico
#install nrpe exploit	   # installé via nrpe-nagios-plugin
installtool dnSpy reverse		#reverse de binaires .NET
installtool ropgadget exploit	   # tool classique de recherche de gadgets pour exploit rop
installtool BlueKeep exploit
installtool zerologon-dirkjanm exploit
installtool pywsus exploit
installtool ItWasAllADream exploit
installtool printnightmare-LPE-powershell exploit
installtool proxyshell exploit

#######################
########  SE  #########
#######################


#######################
########  Code ########
#######################

#install lapse auditCode
#installtool milk auditCode
#installtool RATS auditCode
#installtool dependencycheck auditCode
#installtool brakeman auditCode
#installtool pylama auditCode

#######################
########  Conf ########
#######################

installtool vulners privesc-linux
installtool linenum privesc-linux
installtool linuxprivchecker privesc-linux
installtool linux-exploit-suggester privesc-linux
installtool unix-privesc-check privesc-linux
installtool windowsEnum privesc-windows
installtool windows-privesc-check privesc-windows
installtool windows-exploit-suggester privesc-windows
installtool WinPwn privesc-windows
installtool JAWS privesc-windows
installtool WSuspicious privesc-windows
installtool spectremeltdownchecker privesc-linux


#######################
###### Hardware #######
#######################

installtool ols hardware
installtool flashrom hardware
installtool firmware-mod-kit hardware
#installtool grub-unlzma hardware
installtool uboot-mdb-dump hardware
#installtool arm_now hardware
installtool pcileech hardware
installtool buspirate hardware
installtool lpc_sniffer_tpm hardware

#######################
######## Cheat ########
#######################

installtool chsh cheatsheets
installtool myCheatSheets cheatsheets


installnetworkminer
#installpycharm
#installEtherpad
installjython
installdbeaver

exit 0
