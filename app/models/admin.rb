class Admin < ActiveRecord::Base
  attr_accessible :password,:password_confirmation, :role, :username

  has_secure_password


  validates :password, presence:true, allow_blank:false
  validates_presence_of :username, :role, allow_blank:false
  validates_uniqueness_of :username
  validates_inclusion_of :role, :in=> %w(Principal Office)
end
