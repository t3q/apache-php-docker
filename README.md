This image is dedicated for my PHP & APACHE applications deployment.

If you with to attach DB, type below:
<code>
sudo docker pull mysql
sudo docker pull phpmyadmin/phpmyadmin

sudo docker run --name mysql -e MYSQL_ROOT_PASSWORD=[my password] -d mysql:tag
sudo docker run --name phpmyadmin -d --link mysql:db -p 8081:80 phpmyadmin/phpmyadmin
</code>
