#!/bin/sh

if [[ $1 == --help ]]
  then
    echo "USAGE : ./$0 domain_name domain_extension password mail"
  elif [[ $# == 4 ]]
   then
    echo "Creating ..."
    name=$1
    ext=$2
    pass=$3
    mail=$4

    echo "Add user ..."
    useradd $name --password $pass -m

    echo "Creating /home/$name/www directory ..."
    cd /home/$name/
    mkdir www
    chown $name www

    echo "Configure DNS ..."
    echo "
    
zone \"$name.$ext\" {
    type master;
    file \"/etc/bind/db.$name.$ext\";
    allow-transfer {xxx.xxx.xx.xxx;}; # SECONDARY DNS
    allow-query{any;};
    notify yes;
};
" >> /etc/bind/named.conf.local

    touch /etc/bind/db.$name.$ext
    echo "
; $name.$ext
\$TTL    3600
; xxxxx IP SERVER (here it's for a kimsufi)
@   IN  SOA nsxxxxxxx.ip-x-xxx-xxx.eu. root.$name.$ext. (
            2011020906 ; SERIAL
            3600; REFRESH
            15M; RETRY
            1W; EXPIRE
            600 ) ; Negative Cache TTL
;
; NAMESERVERS
;
$name.$ext. IN       NS       nsxxxxxxx.ip-x-xxx-xxx.eu.
$name.$ext. IN       NS       ns.kimsufi.com.
    
; Nodes in domain
;
www       IN A         x.xxx.xxx.xxx
mail      IN A         x.xxx.xxx.xxx
ns1       IN A         x.xxx.xxx.xxx
smtp      IN A         x.xxx.xxx.xxx
pop       IN A         x.xxx.xxx.xxx
ftp       IN A         x.xxx.xxx.xxx
imap      IN A         x.xxx.xxx.xxx
$name.$ext.   IN  A   x.xxx.xxx.xxx
$name.$ext.   IN  MX  10 mail.$name.$ext.
ownercheck   IN  TXT "0b3bfac0"
;
; subdomains
;
*.$name.fr. IN A x.xxx.xxx.xxx
" >> /etc/bind/db.$name.$ext

    /etc/init.d/bind9 reload

    echo "Configure apache ..."
    cd /etc/apache2/sites-available
    touch $name.$ext
    echo "
<VirtualHost *:80>
    ServerAdmin $mail
    ServerName www.$name.$ext
    ServerAlias $name.$ext
    DocumentRoot /home/$name/www
    <Directory />
            Options FollowSymLinks
            AllowOverride All
    </Directory>
    <Directory /home/$name/www>
            Options FollowSymLinks MultiViews
            AllowOverride All
            Order allow,deny
            allow from all
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    LogLevel warn
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> $name.$ext
    a2ensite $name.$ext
    service apache2 reload

    echo "Creating index.html ..."
    cd /home/$name/www
    touch index.html
    echo "Ceci est une page de test !" >> index.html
    chown $name index.html

    echo "Done !"
  else
    echo "ERROR : not enough args... Run ./$0 --help to print usage !"
fi
