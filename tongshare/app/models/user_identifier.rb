# Type should be in {"employee_no", "mobile", "email"}
class UserIdentifier < ActiveRecord::Base
  MAX_VALUE_LENGTH = 128
  TYPE_EMPLOYEE_NO = 'employee_no'
  TYPE_MOBILE = 'mobile'
  TYPE_EMAIL = 'email'
  
  belongs_to :user
  
  validates :login_value, :login_type, :presence => true
  validates_length_of :login_value, :maximum => MAX_VALUE_LENGTH, :message => "长度不能超过#{MAX_VALUE_LENGTH}字节" #TODO: several issues with i18n
  
  # Currently, only three types are supported
  validates_format_of :login_type, :with => /(employee_no)|(mobile)|(email)/

  validates_uniqueness_of :login_value, :scope => :login_type   #it seems this validates uniqueness of [:value, :type]
  #TODO: "Value has already been taken" -> "xxx has already been taken"
  validate :value_format_check

  attr_accessible :login_value, :login_type

  def value_format_check
    case login_type
    when TYPE_EMPLOYEE_NO
      errors.add(:login_value, :employee_no_invalid) if login_value.match(/[0-9]{10}/).nil?   #目前只考虑清华. TODO: 工作证格式？
    when TYPE_MOBILE
      errors.add(:login_value, :mobile_invalid) if login_value.match(/1[0-9]{10}/).nil?
    when TYPE_EMAIL
      #errors.add(:email, :invalid) if login_value.match(/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/).nil?
    end
  end

end
