# 关于image #
  * 别忘了apt-get install libmagickwand-dev，否则不能安装gem 'rmagick'
  * 别忘了apt-get install imagemagick

# 关于邮件！ #
  * 别忘了改production.rb
  * 别忘了装postfix（我记得是要装的）

# 关于db:migration! #
  * 对了，新的deploy.rb中不会自动`db:migration`，因为cap本身有一条命令`cap deploy:migrations`来做这件事情。这样，一来避免了危险的migration行为在每次deploy的时候都会做；二来将部署的步骤分的更加清楚，deploy就是让服务器上的代码和SCM的一致（也就是coding部分的工作），至于数据库的更新则和本地一样需要一条单独的migration命令。
# 关于Unicorn的0 Timedown部署 #
  * kill -USR2是没有错的，但是原来的unicorn.rb中的before\_fork函数没有做到应该做的事情，导致了kill -USR2败了。我改了unicorn.rb中相应的代码就OK了
  * 以前的那个deploy.rb中的4个基础函数比较扯淡，restart中间必须sleep 5……我好像找到这些代码在网上的来源了，原代码没有sleep 5但是整个restart根本不WORK！
  * 貌似实际上restart就应该写成原来的reload，也就是kill -USR2
  * 而原来的stop应该最好不要用，而是用原来的graceful\_stop来代替stop，这样就不会使得已有连接断掉。实际上，reload也采用的是-QUIT，也就是graceful\_stop
  * 然后请照楠帮我解答一下这两个疑问：1、为什么preload\_app = false，貌似网上默认的教程是true？2、以前的before\_fork是参考的哪，为什么那个没有按照USR2的要求进行操作呢？

# 用Capistrano部署 #
> capistrano是针对rails项目的一个部署的脚本框架，它可以与svn或git结合
## 使用方法 ##
  * 初始化
```
    sudo apt-get install capistrano
    cd PROJ_ROOT_DIR
    capify . (only for project with no deploy.rb config file..)
```
  * cap deploy 最常用的命令。它会降代码checkout到目标服务器，然后restart服务
  * cap deploy:update 把svn的代码checkout到目标服务器
  * cap deploy:start 运行目标服务器上的服务
  * 补充：
    1. 如果新部署的版本中，对/config/locales下的文件有改动，那么在执行cap deploy之前，你必须**手动**把/public/javascripts/tranlations.js复制到服务器的/var/www/tongshare/shared/public/javascripts/translations.js

## 配置 ##
> 主要的配置位于 config/deploy.rb 中
  * 配置文件比较易懂，前面主要是配置一些常量。
  * 后半部分定义了几个task，通过cap deploy:XXX调用 task XXX.
  * 需要注意的是，有必要在checkout代码后调用一遍bundle install，以保证插件的完整性。否则服务运行时会不断地抛exception
  * **服务器上新建了一个deployer账号，用来部署，部署时需要输入此账号的密码。**
  * **svn的checkout目前用的是paullzn以及对应的密码，直接写在配置文件当中。**
  * **tongshare服务部署在/var/www/tongshare/**
  * **thuauth服务部署在/var/www/thuauth/**
  * **hack文件夹放在/var/www/hack/**

# 用unicorn+apache运行服务 #
> unicorn 是一个具有UNIX特性的ruby服务器，通常与nginx前端服务器配合使用。
> 这里是官方网站：http://unicorn.bogomips.org/
  * 一个unicorn会启动一个master进程以及N个slave进程。每一个slave跑一个rails实例，unicorn的各个进程的负载完全由linux系统的进程管理来做balance，如果某个slave出了问题就重启一个新的。unicorn可以做到服务的永不掉线。

## 使用方法 ##
  * 一个典型的启动方法是
```
 cd RPOJ_ROOT_DIR
 unicorn_rails -cconfig/unicorn.rb -E development -D
```
  * 运行的unicorn的master进程号会存在tmp/pids目录下
  * unicorn\_rails会根据config/unicorn.rb中的配置运行。
  * -E参数表示运行development版还是production版等
  * -D参数表示后台运行
  * unicorn的错误记录一般会记录在log/unicorn.stderror.log中

## 配置 ##
> Unicorn的配置文件位于config/unicorn.rb中
  * 配置文件也很容易读懂。没有什么特殊的地方。
  * **tongshare 运行在 127.0.0.1:3000**
  * **thuauth 运行在 127.0.0.1:3001**

# Bundle的配置 #
> bundler是Rails3 新加的dependency管理工具，使用比以前的plugin方便。
  * 当前项目所有依赖的插件均记录在Gemfile中，
  * 当代码checkout到一个新的环境中之后，只需运行bundle install，就可以将所需要的所有插件补全，保证服务可以被运行。其中可能会从git上下载代码，需要出国。
  * 项目目录下有一个.bundle隐藏目录，其下有一个config文件，其中记录了插件安装的位置。因为项目的所有文件都由svn控制，所以我将其加入了svn仓库中。

# apache的配置 #
**在httpd-vhost.conf中配置了两个新的Virtual host**
  * **www.tongshare.com 和tongshare.com 指向 127.0.0.1:3000**
  * **thuauth.tongshare.com 指向 127.0.0.1:3001**