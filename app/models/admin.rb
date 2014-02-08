class Admin < ActiveRecord::Base
  attr_accessible :password_digest, :role, :username
end
