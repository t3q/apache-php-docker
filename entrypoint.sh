#!/bin/bash
set -e

if [ -z "$WEBSITE_HOST" ]; then
	WEBSITE_HOST="website"
fi


cat <<EOF >> /etc/apache2/sites-available/vhost.conf
<VirtualHost *:80>
        ServerName $WEBSITE_HOST
        ServerAlias *.$WEBSITE_HOST
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        <Directory /var/www/>
          Require all granted
          Options -Indexes +FollowSymLinks -MultiViews
          Order allow,deny
          allow from all
	      AllowOverride All
        </Directory>
</VirtualHost>
EOF

exec "$@"
