sudo -i

# Install PHP 5.6
yum --enablerepo=remi,remi-php56 install -y php-fpm php-common

# Install PHP 5.6 modules
yum --enablerepo=remi,remi-php56 install -y php-opcache php-pecl-apcu php-cli php-pear php-intl php-exif php-pdo php-mysql php-mysqlnd php-pgsql php-pecl-mongo php-pecl-sqlite php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml php-devel phpunit mysql-client

# Install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Install xdebug
yum install -y gcc gcc-c++ autoconf automake
pecl install Xdebug
echo -e "[xdebug]\nzend_extension=\"/usr/lib64/php/modules/xdebug.so\"\nxdebug.remote_enable = 1\nxdebug.remote_connect_back = 1\nxdebug.idekey = \"vagrant\"" >> /etc/php.ini
sed -i 's/display_errors = .*/display_errors = On/' /etc/php.ini
sed -i 's/display_startup_errors = .*/display_startup_errors = On/' /etc/php.ini

# Install blackfire.io
yum -y install pygpgme
wget -O - "http://packages.blackfire.io/fedora/blackfire.repo" | tee /etc/yum.repos.d/blackfire.repo
yum -y install blackfire-agent
