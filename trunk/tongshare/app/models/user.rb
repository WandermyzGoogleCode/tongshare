# Note! sharing is the sharing created by user.
# user_sharing is the sharing that shares to this user.
# All sharing shares to this user should also include
# group_sharing that related to this user
# 注意！this.sharings只是由该user创建的sharing（分享）。
# this.user_sharings只是专门针对该user的sharing。
# 所有和该用户相关的分享（即分享给用户的事件）还应该包含
# 该用户所在的群组相关的this.groups.group_sharings。
#
class User < ActiveRecord::Base
  has_many :user_identifier, :dependent => :destroy
  has_many :group, :foreign_key => "creator_id", :dependent => :destroy
  has_many :membership, :dependent => :destroy
  has_many :event, :foreign_key => "creator_id", :dependent => :destroy
  has_many :acceptance, :dependent => :destroy
  has_many :sharing, :foreign_key => "shared_from", :dependent => :destroy
  has_many :user_sharing, :dependent => :destroy
end
