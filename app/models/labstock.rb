class Labstock < ActiveRecord::Base
  attr_accessible :lab_id, :office_id, :quantity, :quantity_used, :status
end
