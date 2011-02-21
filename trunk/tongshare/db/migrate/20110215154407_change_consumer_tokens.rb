class ChangeConsumerTokens < ActiveRecord::Migration
  def self.up
    change_column :consumer_tokens, :token, :string, :limit => 512
  end

  def self.down
    change_column :consumer_tokens, :token, :string, :limit => 124
  end
end
