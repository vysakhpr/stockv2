class Message < ActiveRecord::Base
  attr_accessible :department_id, :lab_id, :message_type, :name, :quantity, :sender

  belongs_to :department
  belongs_to :lab

  validates_presence_of :department_id,:lab_id,:message_type,:sender
  validates_inclusion_of :sender,:in=>%w(Lab HOD)
  validates_inclusion_of :message_type,:in=>%w(writeoff ack request info)
end
