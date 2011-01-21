# Note! sharing is the sharing created by user.
# user_sharing is the sharing the shares to this user.
# All sharing shares to this user should also include
# group_sharing that related to this user
class User < ActiveRecord::Base
  has_many :user_identifier, :dependent => :destroy
  has_many :group, :foreign_key => "creator_id", :dependent => :destroy
  has_many :membership, :dependent => :destroy
  has_many :event, :foreign_key => "creator_id", :dependent => :destroy
  has_many :acceptance, :dependent => :destroy
  has_many :sharing, :foreign_key => "shared_from", :dependent => :destroy
  has_many :user_sharing, :dependent => :destroy
end
