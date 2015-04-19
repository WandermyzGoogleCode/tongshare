# 注册 #
  * 直接用手机版的网页吧
# 登录 #
  * 为了简便起见（绕开表单提交验证），直接用手机版的网页，登录后可以在当前URL里看到一个参数auth\_token，直接将这个auth\_token记录下来，在以后所有的HTTP请求时附上这个GET参数，即可通过用户验证
# 事件获取 #
> （暂时还没完成，预计明天晚上前给开放出来，区别于以前的主要是返回instance，判断用户身份）
  * 1 parameter: http://tongshare.com/private/get_diff.json?auth_token=X
  * 2 parameters: http://tongshare.com/private/get_diff.xml?auth_token=X&last_update=2011/3/1
  * 上述两个API中，last\_update是一个可以省略的参数，表示上一次客户端获取活动的时间，服务器将返回所有有变化的活动的JSON或者XML（看get\_diff.json还是get\_diff.xml）。省略last\_update将获得所有事件的信息。注意，现在的系统貌似还不支持删除活动后的同步，这个等会我们看刘超那边调研的ICALENDAR是怎么处理删除的情况的。
  * 刘洋使用过这样类似的接口，所以你们可以向他要现成的代码
# 报到、报警 #
  * `http://tongshare.com/event/<event_id>?auth_token=X&feedback=[check_in | warning]&inst=<instance_id>`
  * 其中参数feedback为check\_in时是报道，warning时是报警。

<event\_id>

是报警或报到事件的ID，

<instance\_id>

是具体小事件的ID（比如微积分课是一个event，每周的课是一个小事件instance）。