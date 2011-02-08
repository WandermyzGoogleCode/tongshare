# Note! sharing is the sharing created by user.
# user_sharing is the sharing the shares to this user.
# All sharing shares to this user should also include
# group_sharing that related to this user

#by Wander: add columns for devise. NOTE: do not use 'email' in this table, use that in the user_extra instead. Will delete 'email' column in the future. 
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, 
         :token_authenticatable, #for mobile auto-login
         :recoverable, :rememberable, :trackable, :validatable
         #no registerable, we will rewrite it.
         #no confirmable, we will rewrite it

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :user_identifier, :dependent => :destroy
  has_many :group, :foreign_key => "creator_id", :dependent => :destroy
  has_many :membership, :dependent => :destroy
  has_many :event, :foreign_key => "creator_id", :dependent => :destroy
  has_many :acceptance, :dependent => :destroy
  has_many :sharing, :foreign_key => "shared_from", :dependent => :destroy
  has_many :user_sharing, :dependent => :destroy
end
