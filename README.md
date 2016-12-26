This image is dedicated for my PHP & APACHE applications deployment.

If you with to attach DB, type below:
<code>
sudo docker pull mysql
sudo docker pull phpmyadmin/phpmyadmin
<code>
sudo docker run -d --name mysql-container -v /data/db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=65hGfrt^53fhDwz@1bhF mysql:latest
</code>
<code>
sudo docker run -d --name phpmyadmin-container --link mysql-container:mysql -p 8081:80 -e PMA_ARBITRARY=1 phpmyadmin/phpmyadmin
</code>

Copy original files into new volume
<code>
sudo docker run -it \
-v /data/pure-ftpd:/etc/pure-ftpd-new \
--link pureftpd-container:jzt3q/pureftpd \
--rm jzt3q/pureftpd sh -c 'exec cp -R /etc/pure-ftpd/* /etc/pure-ftpd-new'
</code>

Start a new pureftpd container
<code>
sudo docker run -d --name pureftpd-container \
    -v /data/ftpusers:/home/ftpusers \
    -v /data/pure-ftpd:/etc/pure-ftpd \
    -p 21:21 -p 30000-30009:30000-30009 \
    -e "PUBLICHOST=localhost" \
    jzt3q/pureftpd
</code>

Add an user
<code>
sudo docker run -it \
-v /data/pure-ftpd:/etc/pure-ftpd \
--link pureftpd-container:jzt3q/pureftpd \
--rm jzt3q/pureftpd sh -c 'exec pure-pw useradd webcontent -u ftpuser -d /home/ftpusers/webcontent'
</code>
<code>
sudo docker run -it \
-v /data/pure-ftpd:/etc/pure-ftpd \
--link pureftpd-container:jzt3q/pureftpd \
--rm jzt3q/pureftpd sh -c 'exec pure-pw mkdb'
</code>

<code>
sudo docker run -d --name phpapache2-container \
    --link mysql-container:mysql \
    -p 8080:80 \
    -v /data/ftpusers/webcontent:/var/www \
    -v /data/www-logs:/var/log/apache2 \
    -e WEBSITE_HOST=IP \
    jzt3q/apache-php

</code>
