# 分享的一点复杂逻辑 #
  * 麻烦在于：一个事件可有多个分享，一个人可以把一个事件分享多次，一个人可以收到从不同的人来的对同一个事件的分享，一个人接受或拒绝一个事件后其他人还可能会邀请其参加这个事件
  * event/show
    * 来自他人的邀请
      * 未决定：xxx把该事件分享给你：“blablbla“。接受/拒绝
      * 已接受：xxx把该事件分享给你：“blablbla“。退出活动
      * 已拒绝：xxx把该事件分享给你：“blablbla“。你已拒绝该活动。重新接受
    * 已发送的邀请
      * （如果添加邀请时，被邀请人已经接受/拒绝了该活动，则在这里直接显示出结果）
  * event/index
    * 邀请列表：没有acc的
  * 邮件提醒：
    * 为简化，无论对方是否已接受/拒绝这个活动，都发送提醒。（这样也能让对方在拒绝活动后有机会“反悔“而重新接受活动）

# `[All Finished]`HIGHEST TODO! #
  * 自动登录
  * 确保各种EMAIL，手机等登录选项都给去掉（注册、登录、首页上都有可能有这些东西）
  * 把PC网页那堆根本不存在的功能如“个人信息”“日历同步”什么的给去掉……
  * 手机的登录、注册界面没对其，LABEL多行，很丑
  * “记住我“自动选上，至少手机上自动选
  * 手机的弹框登录问题！（首页登录没问题，但是一旦首页登录失败，跳转到登录页面就会弹框）
  * FLASH的提示文字的位置很丑

# 2.20 plan #
  * WAP功能完善
    * 注册
    * 注销
  * WAP界面完善
    * 主要应该是注册和登录界面比较不能忍
  * 用户在点了一个instance后，会转到event显示页面，所以只会显示第一个instance的开始结束时间和重复逻辑，但不会显示用户点击的这个instance的开始结束时间
  * 若干issue (速度的问题我先去看一下)
  * PC主页登录的左面有问题，空白也比多余一个“立即注册”好。在没有内容前，建议用图片或者什么填充空间。
  * “日程”改为“活动”，有些地方应该还没改
  * 验证时传递密码

# mile stone 1 #
  * 用户系统完善
    1. i18n
    1. Remember Me
    1. 忘记密码
    1. 学生清华验证
      * 依赖：协议制定
  * 界面
    1. 登录/注册入口
    1. 新建事件
      * 依赖接口：新建事件 （尤其是：我还不知道重复逻辑最后怎么样了……）
        * SpaceFlyer: 目前据我了解，没有接口，但是可以通过Event.new + generate\_instances搞。刘超最好还是封装一下。最后的重复逻辑采用了生成instances，允许override的办法，因此多出了一个instances表，belongs to event
      * 依赖接口：事件分享（或者：现在操作sharing和user\_sharing有什么要注意的地方吗？）
        * SpaceFlyer: 我好像没看到有关sharing的任何commit?
      * 依赖接口：邮件提醒（这个谁做？）
        * SpaceFlyer: 嗯，Good question，这个貌似需要讨论吧，不知道具体的情况、难度以及依赖性。
    1. 显示当天事件
      * 依赖接口：按时间段查询事件（希望接口能把计算重复逻辑的工作完成）
        * SpaceFlyer: 有instances，所以不需要计算重复逻辑
    1. 编辑事件详情（包括查看反馈）
    1. 查看用户有空状态
      * 问题：可以查看什么人的有空状态？如果是所有人，那就得做搜索用户的功能。另外，默认是可以让别人知道自己有空没空是吗？这不太好吧？貌似就需要权限系统了。所以我觉得是否这个功能可以先不在mile stone 1里
        * SpaceFlyer: 所有人，不需要搜索，一开始先从输入用户的employee\_num, email等，或者点击链接（比如查看同一个活动的人的有空时间）进行查看。只是否busy这个我觉得不是什么大不了的事情吧，google calendar默认也是可以看到的。而且日历上的只是一个参考，又不能作为证据什么的。我觉得这是一个很重要的incentive，有了这个用户会顿时觉得日程表确实应该online and shared.

# Compile Ruby 1.9.2 #
  * NetBeans: patch org-netbeans-modules-ruby-railsprojects.jar  to /ruby/modules
  * apt-get sqlite3
  * apt-get libsqlite3-dev
  * apt-get libncurses5-dev libreadline5-dev
  * 如果有模块没有编译进去，用apt-get装好依赖以后
```
go to the <ruby_src>/ext/xxx, 
  ruby extconv.rb    #generate valid makefile
  make
  make install
```