class Department < ActiveRecord::Base
  attr_accessible :name, :password_digest, :username
end
