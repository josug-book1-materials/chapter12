#!/bin/sh

cd $(dirname $0)

echo 'Updating all packages (it takes some time ...)'
yum update -q -y ca-certificates --disablerepo=epel
yum update -q -y

echo 'Installing ruby'
rpm -ivh rpm/ruby-2.1.3.el6.x86_64.rpm
yum groupinstall -q -y 'Development Tools'
yum install -q -y readline-devel openssl-devel


echo 'Installing fog and chef'
echo "install: --no-document" >> ~/.gemrc 
echo "update:  --no-document" >> ~/.gemrc

gem install bundler
bundle install

useradd chef
echo 'chef ALL=(ALL) ALL' > /etc/sudoers.d/chef
chmod 600 /etc/sudoers.d/chef


echo 'Getting cookbooks'
su - chef -c 'cd $HOME; git clone https://github.com/josug-book1-materials/chapter12.git'
su - chef -c 'cd $HOME/chapter12/chef-repo-openstack-sample; berks vendor cookbooks'

echo "##### Building environment completed #####"
