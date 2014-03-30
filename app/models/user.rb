class User < ActiveRecord::Base
  attr_accessible :role, :username
  validates :username, :presence=> true, :uniqueness => true
  validates_inclusion_of :role, :in=> %w(Admin HOD Lab)
end
