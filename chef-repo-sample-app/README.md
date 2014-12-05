OpenStack 書籍サンプル Cookbook 用 Chef-Repo
====

Overview
----

OpenStack 書籍用のサンプル Chef-Repo です。

下記を含む Cookbooks をダウンロードするための Berksfile とRole ファイルとで構成されています。

* https://github.com/jedipunkz/cookbook-openstack-sample

Requirements
----

下記のソフトウェアがインストールされている前提です。

* Chef
* Berkshelf

この2つのソフトウェアをインストールするための Gemfile を含んでいます。インストールするには下記の操作を行います。

    % gem install bundler
    % git clone https://github.com/jedipunkz/chef-repo-openstack-sample.git
    % cd chef-repo-openstack-sample
    % bundle install

Usage
----

下記の操作で Cookbooks をダウンロードして下さい。

    % git clone https://github.com/jedipunkz/chef-repo-openstack-sample.git
    % cd chef-repo-openstack-sample
    % berks vendor cookbooks

下記の Cookbooks がダウロードされます。

* aws
* chef-sugar
* iptables
* mysql-chef_gem
* openstack-sample
* python
* xfs
* yum-epel
* apt
* build-essential
* database
* mysql
* openssl
* postgresql
* selinux
* yum
* yum-mysql-community

Chef サーバに Cookbooks をアップロードします。

    % knife cookbook upload -a

Roles をアップロードします。

    % knife role from file roles/*.rb

データベースサーバ 'dbs01'からデプロイします。knife コマンドを用いて下記のように実行してください。

    % knife bootstrap -N dbs01 192.168.0.4 -r 'role[db]' -x root  -i key-for-internal.pem

続いて Web サーバ 'web01' のデプロイを実施します。

    % knife bootstrap -N web01 192.168.0.1 -r 'role[web]' -x root  -i key-for-internal.pem

続いて App サーバ 'app01' のデプロイを実施します。

    % knife bootstrap -N web01 192.168.0.3 -r 'role[rest]' -x root  -i key-for-internal.pem

Author
----

Tomokazu HIRAI (@jedipunkz)

