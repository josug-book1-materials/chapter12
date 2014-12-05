chapter12
=========

OpenStack 書籍 第12章用レポジトリ

格納しているファイル達
----

* Ruby RPM

rpm ディレクトリに格納されているのはOpenStack書籍で扱う 'centos-base' イメージ用の ruby 2.1.3 (執筆時点最新ステーブル版)の RPM パッケージです。

* Fog サンプルコード

fog ディレクトリに格納されているのは書籍で扱う Fog 用サンプルコードです。

* Fog パッチ

patch-fog ディレクトリに格納されているのは Fog に対するパッチです。サブネット作成の際にゲートウェイ無しを選択出来ない不具合を修正するためのパッチです。

* chef-repo

chef-repo-openstack-sample ディレクトリに格納されているのは12章用のChefを扱うためのChef-Repoです。

その他のレポジトリ
----

本レポジトリとは別に第12章では Chef 用のレポジトリを用います。Berkshelf で取得するため別のレポジトリとして保管してあります。

* cookbook-opensatck-sample

    https://github.com/josug-book1-materials/cookbook-openstack-sample

* nginx

    https://github.com/josug-book1-materials/nginx

Berkshelf によるクックブック取得
---

上記2つのレポジトリを含む Chef デプロイのためのクックブックを取得するため下記のように Berksfile を作成する。

```
$ cat Berksfile
source "https://supermarket.getchef.com"

cookbook 'selinux'
cookbook 'python'
cookbook 'mysql'
cookbook 'iptables'
cookbook 'database'
cookbook 'nginx', git: 'https://github.com/josug-book1-materials/nginx.git'
cookbook 'openstack-sample', git: 'https://github.com/josug-book1-materials/cookbook-openstack-sample.git'
```

作成した Berksfile を元に berks コマンドでクックブックを取得するために下記のコマンドを実行する。

```bash
$ berks vendor cookbooks
```

