user=admin
paths=/home/$user/php-5.3.6
cd $paths

./configure --prefix=/home/$user/php --with-apxs2=/home/$user/apache/bin/apxs \
--with-config-file-path=/home/$user/php/lib --with-mysql=/home/$user/mysql \
--with-pdo-mysql=/home/$user/mysql --with-curl=/home/$user/curl --enable-mbstring

make && make install

cp php.ini-recommended ~/php/lib/php.ini






