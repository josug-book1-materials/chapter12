RPM for OpenStack' Book
====================

OpenStack 書籍で扱う踏み台サーバ (centos-base イメージ) にて Ruby 2 系の最新版2.1.3 (2014年10月現在) をインストールするための RPM パッケージと RPM をビルドするための SPEC ファイルを収容。Chef, Fog, Berkshelf をインストールするための環境である。

ビルド方法
----

ビルドするために必要なソフトウェアのインストールを行う。

```bash
# yum groupinstall 'Development Tools'
# yum install readline-devel libyaml-devel
# yum install gdbm-devel tcl-devel openssl-devel db4-devel
```

EPEL レポジトリを有効にする

```bash
# rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
```

一般ユーザでビルドを行う
----

```bash
% cd $HOME
% git clone https://github.com/jedipunkz/rpm-openstack-sample.git
% mkdir -p ~/rpmbuild/{BUILD,SOURCES,SPECS,SRPMS,RPMS}
% cd ~/rpmbuild
% wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz ~/rpmbuild/SOURCES/ruby-2.1.3.tar.gz
% cp rpm-openstack-sample/ruby.spec ~/rpmbuild/SPECS/ruby.spec
% rpmbuild -bb ~/rpmbuild/SPECS/ruby.spec
```

RPM の利用方法
----

RPM と Chef, Fog, Berkshelf などに必要なソフトウェアをインストールする。

```bash
% sudo -i
# cd $HOME
# git clone https://github.com/jedipunkz/rpm-openstack-sample.git
# rpm -ivh rpm-openstack-sample/ruby-2.1.3.el6.x86_64.rpm
# yum groupinstall 'Development Tools'
# yum install readline-devel
```

