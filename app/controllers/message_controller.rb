class MessageController < ApplicationController
  include ApplicationHelper
  include DepartmentHelper
  include AdminHelper
  include LabHelper
	def writeoff
		@message=Message.new(:department_id=>current_user.department.id,:lab_id=>current_user.id,:message_type=>"writeoff",:sender=>current_user_type)
		if @message.save
			flash[:notice]="Requested"
	    else 
	    	flash[:error]=@message.errors.full_messages.to_sentence
	    end
	    redirect_to :back
 	end

 	def need_stock
 		@message=Message.new(:department_id=>current_user.department.id,:lab_id=>current_user.id,:message_type=>"request",:name=>params[:name],:quantity=>params[:quantity].to_i,:sender=>current_user_type)
		if @message.save
			flash[:notice]="Requested"
	    else 
	    	flash[:error]=@message.errors.full_messages.to_sentence
	    end
	    redirect_to :back
 	end
end
