# Type should be in {"company_id", "mobile", "email"}
class UserIdentifier < ActiveRecord::Base
  MAX_VALUE_LENGTH = 128
  TYPE_COMPANY_ID = 'company_id'
  TYPE_MOBILE = 'mobile'
  TYPE_EMAIL = 'email'
  
  belongs_to :user
  
  validates :value, :type, :presence => true
  validates_length_of :value, :maximum => MAX_VALUE_LENGTH, :message => "长度不能超过#{MAX_VALUE_LENGTH}字节" #TODO: several issues with i18n
  
  # Currently, only three types are supported
  validates_format_of :type, :with => /(company_id)|(mobile)|(email)/

  validate :value_format_check

  attr_accessible :value, :type

  def value_format_check
    case type
    when TYPE_COMPANY_ID
      errors.add(:company_id, '格式不正确') if value.match(/[0-9]{10}/).nil?   #目前只考虑清华. TODO: 工作证格式？
    when TYPE_MOBILE
      errors.add(:mobile, '格式不正确') if value.match(/1[0-9]{10}/).nil?
    when TYPE_EMAIL
      errors.add(:email, '格式不正确') if value.match(/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/).nil?
    end
  end
end
