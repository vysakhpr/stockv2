class Department < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation, :username

  has_many :labs, dependent: :destroy
  has_many :offices
  has_many :messages, dependent: :destroy

  has_secure_password

  validates :password, presence:true, allow_blank:false
  validates_presence_of :name, :username, allow_blank:false
  validates_uniqueness_of :username

end
