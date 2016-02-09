#!/bin/sh

cd $(dirname $0)

echo 'Updating all packages (it takes some time ...)'
yum update -q -y ca-certificates --disablerepo=epel
yum update -q -y

echo 'Installing ruby'
yum groupinstall -q -y 'Development Tools'
yum install -q -y gcc make git parted readline-devel\
python-devel python-crypto python-pip mysql-devel \
libxml2 libxml2-devel libxslt libxslt-devel \
libffi libffi-devel openssl-devel libyaml libyaml-devel
rpm -ivh rpm/ruby-2.1.3.el6.x86_64.rpm

echo 'Installing fog and chef'
echo "install: --no-document" >> ~/.gemrc 
echo "update:  --no-document" >> ~/.gemrc

gem install bundler
bundle install

useradd fog
echo 'fog ALL=(ALL) ALL' > /etc/sudoers.d/fog
chmod 600 /etc/sudoers.d/fog


echo 'Getting cookbooks'
su - fog -c 'cd $HOME; git clone https://github.com/josug-book1-materials/chapter12.git'
su - fog -c 'cd $HOME/chapter12/chef-repo-sample-app; berks vendor cookbooks'

echo "##### Building environment completed #####"
