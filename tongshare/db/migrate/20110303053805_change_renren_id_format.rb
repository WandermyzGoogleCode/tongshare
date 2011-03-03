class ChangeRenrenIdFormat < ActiveRecord::Migration
  def self.up
    execute("UPDATE user_extras SET renren_id = 'id:'||renren_id WHERE NOT (renren_id LIKE 'domain:%') ")
    # || means concat
  end

  def self.down
    execute("UPDATE user_extras SET renren_id = SUBSTR(renren_id, 4) WHERE renren_id LIKE 'id:%'")
  end
end
