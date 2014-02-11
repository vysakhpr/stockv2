class Message < ActiveRecord::Base
  attr_accessible :department_id, :lab_id, :message_type, :name, :quantity, :sender

  validates_presence_of :department_id,:lab_id,:message_type,:name,:quantity,:sender
  validates_inclusion_of :sender,:in=>%w(Lab HOD)
  validates_inclusion_of :message_type,:in=>%w(info request acknowledgement)
end
