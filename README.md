# vagrant-dev-php
Vagrant box for PHP software development.

This box is only environment with various software required to run and debug php application.

PHP application itself is not part of this box and is mounted via vagrant shared folders (NFS).

## What's inside

Software:
- Centos 7.0 (64-bit) [puppetlabs/centos-7.0-64-nocm](https://atlas.hashicorp.com/puppetlabs/boxes/centos-7.0-64-nocm)
- PHP 5.6 (FPM)
- nginx
- composer
- blackfire.io agent
- xdebug

#### [PHP Modules]
`apc`, 
`apcu`, 
`bz2`, 
`calendar`, 
`Core`, 
`ctype`, 
`curl`, 
`date`, 
`dom`, 
`ereg`, 
`exif`, 
`fileinfo`, 
`filter`, 
`ftp`, 
`gd`, 
`gettext`, 
`hash`, 
`iconv`, 
`igbinary`, 
`intl`, 
`json`, 
`libxml`, 
`mbstring`, 
`mcrypt`, 
`memcache`, 
`memcached`, 
`mhash`, 
`mongo`, 
`msgpack`, 
`mysql`, 
`mysqli`, 
`mysqlnd`, 
`openssl`, 
`pcntl`, 
`pcre`, 
`PDO`, 
`pdo_mysql`, 
`pdo_pgsql`, 
`pdo_sqlite`, 
`pgsql`, 
`Phar`, 
`posix`, 
`readline`, 
`Reflection`, 
`session`, 
`shmop`, 
`SimpleXML`, 
`soap`, 
`sockets`, 
`SPL`, 
`SQLite`, 
`sqlite3`, 
`standard`, 
`sysvmsg`, 
`sysvsem`, 
`sysvshm`, 
`tidy`, 
`tokenizer`, 
`wddx`, 
`xdebug`, 
`xml`, 
`xmlreader`, 
`xmlwriter`, 
`xsl`, 
`Zend OPcache`, 
`zip`, 
`zlib`

####[Zend Modules]
`Xdebug`, 
`Zend OPcache`

## Prerequisites
- Unix-like OS
- Vagrant >= 1.6.0
- VirtualBox (others not tested)
- Host NFS (```sudo apt-get install -y nfs-kernel-server```)
- Vagrant hostsupdater plugin (```vagrant plugin install vagrant-hostsupdater```)
- Vagrant vbguest plugin (```vagrant plugin install vagrant-vbguest```)
- VirtualBox >=4.3.0

## Installation

1. ```git clone git@github.com:darneta/vagrant-dev-php.git```
1. ```cd vagrant-dev-php```
1. ```cp config.example.yml config.yml```
1. ```vagrant up```
1. Open http://dev.local - you should see phpinfo

## Usage

1. Stop vagrant box if running ```vagrant halt```
2. Add your project or multiple projects to `www` folder (```ln -s /path/to/my/osom/project ./www/osom-project```)
3. Create nginx vhost file/files `./sites-enabled/osom-project` (see vhost example in `Usage Example` section)
4. Start vagrant ```vagrant up```
5. Open virutal domains specifieded in nginx vhost file ```server_name```

## Usage Example

In this example we will run symfony2 inside this box. 

Get symfony2 installer:
```bash
sudo curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
sudo chmod a+x /usr/local/bin/symfony
```
Install symfony into `www` folder:
```bash
cd ./www
symfony new symfony2
cd ..
```
Create nginx vhost file for symfony2 `./sites-enabled/symfony2` with content:
```nginx
server {
    root /srv/www/symfony2/web;

    server_name symfony2.local www.symfony2.local;

    rewrite ^/app\.php/?(.*)$ /$1 permanent;

    location / {
        index app.php;
        try_files $uri @rewriteapp;
    }
 
    location @rewriteapp {
        rewrite ^(.*)$ /app.php/$1 last;
    }
 
    # pass the PHP scripts to FastCGI server from upstream phpfcgi
    location ~ ^/(app|app_dev|config)\.php(/|$) {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param  HTTPS off;
    }
}
```

Notice:
* Guest `/srv/www` coresponds to host `./www` folder (projects folder)
* `server_name` values will be automatically added to host `/etc/hosts` file 

Start vagrant box:
```bash
vagrant up
```
Open [http://www.symfony2.local](http://www.symfony2.local)

## Folders structure

|-`bootstrap` scripts and resources required to provision box (no need to worry about this).  
|-`sites-enabled` nginx servers (vhosts) files. Will be automatically loaded to nginx config.  
|-`www` folder of php applications folders or/and symlinks.

## Known issues

* Symlinks within your project may not work.
* Due to NFS project filesystem IO is 10%~70% slower (however default VirtualBox shared folders is ~2300% slower).
