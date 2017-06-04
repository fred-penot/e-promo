mkdir -p /home/docker/app
cd /home/docker/app
wget https://symfony.com/installer
mv -f installer symfony
/usr/local/zend/bin/php symfony new epromo
chmod 755 -Rf /home/docker/app
chown -Rf docker:docker /home/docker/app
