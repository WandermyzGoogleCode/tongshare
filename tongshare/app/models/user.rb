
# 注意！this.sharings只是由该user创建的sharing（分享）。
# this.user_sharings只是专门针对该user的sharing。
# 所有和该用户相关的分享（即分享给用户的事件）还应该包含
# 该用户所在的群组相关的this.groups.group_sharings。
#

# by Wander: add columns for devise. 

class User < ActiveRecord::Base

  NIL_EMAIL_ALIAS_DOMAIN = 'null.tongshare.com' #see registration_extended_controller

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, 
         :token_authenticatable, #for mobile auto-login
         :recoverable, :rememberable, :trackable,
         :registerable,
         :validatable,
         :authentication_keys => [:id]
       
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :id
  has_many :user_identifier, :dependent => :destroy
  has_many :group, :foreign_key => "creator_id", :dependent => :destroy
  has_many :membership, :dependent => :destroy
  has_many :event, :foreign_key => "creator_id", :dependent => :destroy
  has_many :acceptance, :dependent => :destroy
  has_many :sharing, :foreign_key => "shared_from", :dependent => :destroy
  has_many :user_sharing, :dependent => :destroy

  has_one :user_extra, :dependent => :destroy
  has_one :admin_extra, :dependent => :destroy
  has_one :google, :class_name => "GoogleToken", :dependent=> :destroy
  #FIXME hack!
  has_many :consumer_tokens, :class_name => "GoogleToken", :dependent => :destroy


  #merge errors of children into this model
  validate do |user|
    user.user_identifier.each do |identifier|
      next if identifier.valid?
      identifier.errors.each do |attr, err|
        errors.add attr, err
      end
    end
  end

  #skip sth. useless like "user_identifier is invalid"
  after_validation :purge_useless

  def purge_useless
    errors.delete :user_identifier
  end
end