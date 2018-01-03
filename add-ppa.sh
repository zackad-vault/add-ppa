#!/usr/bin/env sh
if [ $# -eq 1 ]
NM=`uname -a && date`
NAME=`echo $NM | md5sum | cut -f1 -d" "`
CODENAME=`lsb_release -c | sed 's/\s//g' | cut -d":" -f2 \
	| sed 's/wheezy/precise/g; s/jessie/trusty/g; s/stretch/xenial/g'`
then
	ppa_name=`echo "$1" | cut -d":" -f2 -s`
	ppa_user=`echo "$ppa_name" | cut -d"/" -f1`
	ppa_package=`echo "$ppa_name" | cut -d"/" -f2`
	list_name=`echo $ppa_name | sed 's/\//-/g'`
	if [ -z "$ppa_name" ]
	then
		echo "PPA name not found"
		echo "Utility to add PPA repositories in your debian machine"
		echo "$0 ppa:user/ppa-name"
	else
		echo "adding ppa:$ppa_name into repository list"
		if grep -q "deb .*$ppa_name" /etc/apt/sources.list /etc/apt/sources.list.d/*;
		then
			echo "canceling, ppa already exists";
			exit 0;
		fi

		# check if curl available
		if [ -x "$(command -v curl)" ]; then
			echo "curl is available"
			key=`curl https://launchpad.net/~$ppa_user/+archive/ubuntu/$ppa_package 2>/dev/null \
				| grep "<code>.*</code>" \
				| sed 's/\s//g; s/code//g; s/<>//g; s/<\/>//g' \
				| cut -d"/" -f2`
			echo $key
		else
			echo "curl is not available"
			echo "deb http://ppa.launchpad.net/$ppa_name/ubuntu $CODENAME main" > /etc/apt/sources.list.d/"$list_name.list"
			echo "updating repository list ..."
			apt-get update >> /dev/null 2> /tmp/${NAME}_apt_add_key.txt
			echo "adding gpg key"
			key=`cat /tmp/${NAME}_apt_add_key.txt | cut -d":" -f6 | cut -d" " -f3`
			echo $key
		fi

		if [ "$key" = "" ]; then
			echo "$key is invalid key ID"
			rm /etc/apt/sources.list.d/"$list_name.list"
			exit 1;
		fi

		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $key

		if [ $exit_status != 0 ]; then
			# cancel adding sources list if failed
			rm /etc/apt/sources.list.d/"$list_name.list"
			exit 1;
		else
			echo "deb http://ppa.launchpad.net/$ppa_name/ubuntu $CODENAME main" > /etc/apt/sources.list.d/"$list_name.list"
			echo "success"
		fi

		rm -rf /tmp/${NAME}_apt_add_key.txt
		echo "ppa:$ppa_name is added to repository"
		echo "please update your package list with 'apt-get update'"
		echo "done"
	fi
else
	echo "Utility to add PPA repositories in your debian machine"
	echo "$0 ppa:user/ppa-name"
fi
