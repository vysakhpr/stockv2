class Lab < ActiveRecord::Base
  attr_accessible :department_id, :name, :password_digest, :username
end
