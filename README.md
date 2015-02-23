# Scripts
Various scripts for server management !

## adddomain.sh
This is a script to easily add a domain on a web server.
A user will also be created for the domain.
It takes 4 args :
- domain_name : the name of your domain (it will be the name of your linux user)
- domain_extension : the extension of your domain without the dot (ex : fr, com, ...)
- password : the password for your linux user
- mail : the mail of the server admin (in the apache conf)

## addsubdomain.sh
This is a script to easily add a subdomain on a web server.
A user will also be created for the subdomain.
It takes 4 args :
- subname : the name of your subdomain (it will be the name of your linux user)
- domain_name : the name of your domain with the extension (ex : github.com)
- password : the password for your linux user
- mail : the mail of the server admin (in the apache conf)






