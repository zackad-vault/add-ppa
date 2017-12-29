#!/usr/bin/env sh 
if [ $# -eq 1 ]
NM=`uname -a && date`
NAME=`echo $NM | md5sum | cut -f1 -d" "`
CODENAME=`lsb_release -c | sed 's/\s//g' | cut -d":" -f2`
then
	ppa_name=`echo "$1" | cut -d":" -f2 -s`
	list_name=`echo $ppa_name | sed 's/\//-/g'`
	if [ -z "$ppa_name" ]
	then
		echo "PPA name not found"
		echo "Utility to add PPA repositories in your debian machine"
		echo "$0 ppa:user/ppa-name"
	else
		echo "$ppa_name"
		echo "deb http://ppa.launchpad.net/$ppa_name/ubuntu $CODENAME main" >> /etc/apt/sources.list.d/"$list_name.list"
		apt-get update >> /dev/null 2> /tmp/${NAME}_apt_add_key.txt
		key=`cat /tmp/${NAME}_apt_add_key.txt | cut -d":" -f6 | cut -d" " -f3`
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $key
		rm -rf /tmp/${NAME}_apt_add_key.txt
	fi
else
	echo "Utility to add PPA repositories in your debian machine"
	echo "$0 ppa:user/ppa-name"
fi
