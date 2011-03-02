class UserExtra < ActiveRecord::Base
  attr_accessible :user_id, :name, :mobile, :renren_url
  belongs_to :user

  validates_format_of :renren_url, :with => /^([0-9]+)|(domain:.+)$/, :allow_nil => true, :allow_blank => true

end
