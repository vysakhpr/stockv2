class Lab < ActiveRecord::Base
  attr_accessible :department_id, :name, :password, :password_confirmation, :username

  has_secure_password

  has_many :labstocks, :dependent=>:destroy
  belongs_to :department
  has_many :messages, :dependent=>:destroy

  validates :password, presence:true, allow_blank:false
  validates_presence_of :name,:username,:allow_blank=>false
  validates_uniqueness_of :username
end
