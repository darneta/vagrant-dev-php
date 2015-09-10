sudo -i

firewall-cmd --permanent --zone=public --add-service=http
systemctl restart firewalld.service

systemctl enable nginx.service
systemctl enable php-fpm.service

systemctl restart nginx.service
systemctl restart php-fpm.service
