class Lab < ActiveRecord::Base
  attr_accessible :department_id, :name, :password, :password_confirmation, :username

  has_secure_password

  has_many :labstocks, :dependent=>:destroy
  belongs_to :department

  validates_presence_of :name,:username
  validates_uniqueness_of :username
end
