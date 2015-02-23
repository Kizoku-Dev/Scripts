#!/bin/sh

if [[ $1 == --help ]]
  then
    echo "USAGE : ./$0 subname domain_name password mail"
  elif [[ $# == 4 ]]
   then
    echo "Creating ..."
    subname=$1
    name=$2
    pass=$3
    mail=$4

    echo "Add user ..."
    useradd $subname --password $pass -m

    echo "Creating /home/$subname/www directory ..."
    cd /home/$subname/
    mkdir www
    chown $subname www

    echo "Configure apache ..."
    cd /etc/apache2/sites-available
    touch $subname.$name
    echo "
<VirtualHost *:80>
    ServerAdmin $mail
    ServerName www.$subname.$name
    ServerAlias $subname.$name
    DocumentRoot /home/$subname/www
    <Directory />
    	Options FollowSymLinks
    	AllowOverride All
    </Directory>
    <Directory /home/$subname/www>
    	Options FollowSymLinks MultiViews
    	AllowOverride All
    	Order allow,deny
    	allow from all
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    LogLevel warn
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> $subname.$name
    a2ensite $subname.$name
    service apache2 reload

    echo "Creating index.html ..."
    cd /home/$subname/www
    touch index.html
    echo "Ceci est une page de test !" >> index.html
    chown $subname index.html

    echo "Done !"
  else
    echo "ERROR : not enough args... Run ./$0 --help to print the usage !"
fi
