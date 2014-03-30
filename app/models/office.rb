class Office < ActiveRecord::Base
searchable do
  text :name
  text :description  
  integer :department_id
end 
  attr_accessible :date, :department_id, :description, :name, :price_unit, :quantity, :total_price, :voucher_no, :quantity_assigned

  has_many :labstocks, dependent: :destroy
  belongs_to :department

  validates_presence_of :date,:department_id,:description,:name,:price_unit,:quantity,:total_price,:voucher_no
  validates_uniqueness_of :voucher_no
  validates_numericality_of :quantity, :integer_only => true, :greater_than=> 0
  validates_numericality_of :quantity_assigned,:integer_only=> true, :greater_than_or_equal_to =>0
  validates :price_unit, numericality: {:greater_than_or_equal_to=>0}
  validates :total_price, numericality: {:greater_than_or_equal_to=>0}
  validates :department_id, numericality:{:greater_than_or_equal_to=>1}
end
