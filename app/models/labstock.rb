class Labstock < ActiveRecord::Base
  attr_accessible :lab_id, :office_id, :quantity, :quantity_used, :status

  belongs_to :lab
  belongs_to :office

  validates_presence_of :lab_id, :office_id,:quantity, :quantity_used, :status
  validates_inclusion_of :status, :in=> %w(P R I W)
end
