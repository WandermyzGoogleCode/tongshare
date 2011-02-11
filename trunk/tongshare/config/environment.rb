# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Tongshare::Application.initialize!

ActiveRecord::Base.connection.instance_variable_set :@logger, Logger.new(STDOUT)  #log SQL statements
