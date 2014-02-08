class Department < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation, :username

  has_many :labs, dependent: :destroy

  validates_presence_of :name, :username
  validates_uniqueness_of :username

end
