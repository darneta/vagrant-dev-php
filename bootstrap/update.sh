sudo -i

## Remi Dependency on CentOS 7 and Red Hat (RHEL) 7 ##
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
 
## CentOS 7 and Red Hat (RHEL) 7 ##
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

## Update
yum -y upgrade
