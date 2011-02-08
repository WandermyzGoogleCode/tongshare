# Type should be in {"company_id", "mobile", "email"}
class UserIdentifier < ActiveRecord::Base
  MAX_VALUE_LENGTH = 128
  
  belongs_to :user
  
  validates :value, :user_id, :type, :presence => true
  validates_length_of :value, :maximum => MAX_VALUE_LENGTH
  
  # Currently, only three types are supported
  validates_format_of :type, :with => /(company_id)|(mobile)|(email)/
end
