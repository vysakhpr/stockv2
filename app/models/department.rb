class Department < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation, :username

  validates_presence_of :name, :username
  validates_uniqueness_of :username
  
end
