sudo -i

# Stop httpd (Apache) server
systemctl stop httpd.service

# Prevent httpd (Apache) autostarting on boot
systemctl disable httpd.service

# Install nginx
yum --enablerepo=remi,remi-php56 install -y nginx

# Copy nginx config
rm /etc/nginx/nginx.conf
cp /bootstrap/etc/nginx/nginx.conf /etc/nginx/nginx.conf
