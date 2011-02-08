
# 注意！this.sharings只是由该user创建的sharing（分享）。
# this.user_sharings只是专门针对该user的sharing。
# 所有和该用户相关的分享（即分享给用户的事件）还应该包含
# 该用户所在的群组相关的this.groups.group_sharings。
#

# by Wander: add columns for devise. 

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, 
         :token_authenticatable, #for mobile auto-login
         :recoverable, :rememberable, :trackable,
         :registerable,
         :authentication_keys => [:id]
         #no confirmable, we will rewrite it
         #no validatable, we will rewrite it

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :id
  has_many :user_identifier, :dependent => :destroy
  has_many :group, :foreign_key => "creator_id", :dependent => :destroy
  has_many :membership, :dependent => :destroy
  has_many :event, :foreign_key => "creator_id", :dependent => :destroy
  has_many :acceptance, :dependent => :destroy
  has_many :sharing, :foreign_key => "shared_from", :dependent => :destroy
  has_many :user_sharing, :dependent => :destroy

  validates :email, :uniqueness => true, :allow_blank => true, :allow_nil => true
end
