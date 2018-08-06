user=admin
paths=/home/$user/php-5.3.6
cd $paths

./configure --prefix=/home/$user/php --enable-fpm \
--with-config-file-path=/home/$user/php/etc --with-curl=/home/$user/curl --enable-mbstring

make && make install
