class Lab < ActiveRecord::Base
  attr_accessible :department_id, :name, :password, :password_confirmation, :username

  validates_presence_of :name,:username
  validates_uniqueness_of :username
end
