#!/bin/bash

export DATAPATH="/usr/share/cobbler"
export DOCPATH="/usr/share/man"
export ETCPATH="/etc/cobbler"
export LIBPATH="/var/lib/cobbler"
export LOGPATH="/var/log"
export COMPLETION_PATH="/usr/share/bash-completion/completions"
export STATEPATH="/tmp/cobbler_settings/devinstall"

export HTTPD_SERVICE="apache2.service"
export WEBROOT="/srv/www";
export WEBCONFIG="/etc/apache2/vhosts.d";
export WEBROOTCONFIG="/etc/apache2";
export TFTPROOT="/srv/tftpboot"
export ZONEFILES="/var/lib/named"
export DEFAULTPATH="etc/sysconfig"
export SHIM_FOLDER="/usr/share/efi/*/"
export SHIM_FILE="shim\.efi"
export IPXE_FOLDER="/usr/share/ipxe/"

# First parameter is DISTRO if provided
[ $# -ge 2 ] && DISTRO="$1"

if [ "$DISTRO" = "" ] && [ -r /etc/os-release ];then
    source /etc/os-release
    case $ID in
	sle*|*suse*)
	    DISTRO="SUSE"
	    ;;
	fedora*|ol*|centos*|rhel*)
	    DISTRO="FEDORA"
	    ;;
	ubuntu*|debian*)
	    DISTRO="UBUNTU"
	    ;;
    esac
fi

if [ "$DISTRO" = "SUSE" ];then
    export APACHE_USER="wwwrun"
    export APACHE_GROUP="www"
elif [ "$DISTRO" = "UBUNTU" ];then
    export APACHE_USER="www-data"
    export HTTP_USER=$APACHE_USER # overrule setup.py
    export APACHE_GROUP="www-data"
    export WEBROOT="/var/www"
    export WEBCONFIG="/etc/apache2/conf-available"
    export ZONEFILES="/etc/bind/db."
    export DEFAULTPATH="etc/default"
    export SHIM_FOLDER="/usr/lib/shim/"
    export SHIM_FILE="shim*\.efi\.signed"
    export IPXE_FOLDER="/usr/lib/ipxe/"
elif [ "$DISTRO" = "FEDORA" ];then
    export APACHE_USER="apache"
    export HTTP_USER=$APACHE_USER # overrule setup.py
    export APACHE_GROUP="apache"
    export HTTPD_SERVICE="httpd.service"
    export WEBROOT="/var/www"
    export WEBCONFIG="/etc/httpd/conf.d"
    export WEBROOTCONFIG="/etc/httpd"
    export TFTPROOT="/var/lib/tftpboot"
    export ZONEFILES="/var/named"
    export SHIM_FOLDER="/boot/efi/EFI/*/"
    export SHIM_FILE="shim[a-zA-Z0-9]*\.efi"
else
    echo "ERROR, unknown distro $DISTRO"
    # ToDo: Should we loudly warn here?
fi
