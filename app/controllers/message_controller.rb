class MessageController < ApplicationController
  include ApplicationHelper
  include DepartmentHelper
  include AdminHelper
  include LabHelper
	def writeoff
        @existing_writeoff=Message.where(lab_id:current_user.id,message_type:"writeoff")
        if @existing_writeoff.exists?
            flash[:error]="You have already issued a Write Off Request"
            redirect_to :back
        else
			@message=Message.new(:department_id=>current_user.department.id,:lab_id=>current_user.id,:message_type=>"writeoff",:sender=>current_user_type)
		  	if @message.save
				flash[:notice]="Requested"
	       	else 
	    		flash[:error]=@message.errors.full_messages.to_sentence
	       	end
	    	redirect_to :back
	    end
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

 	def department_ack
 		@message=Message.find(params[:id])
 		@acknowledgement=Message.new(:department_id=>current_user.id,:lab_id=>@message.lab_id,:message_type=>"ack",:name=>"Your Request has been Acknowledged.. Please wait some time...",:quantity=>0,:sender=>@message.sender)
 		if @acknowledgement.save
 			if @message.destroy
 				flash[:notice]="Acknowledged"
 			else
 				raise ActiveRecord::Rollback
 				flash[:error]="Ooops Something went wrong.. Try Again"
 		    end
 		else
 			flash[:error]="Ooops Acknowledgement Failed"
 	    end
 	    redirect_to :back
    end

    def request_forward
    	@message=Message.find(params[:id])
    	status=@message.message_type=="writeoff" ? "WriteOff" : "Items"
    	@forwarded_message=Message.new(:department_id=>current_user.id,:lab_id=>@message.lab_id,:message_type=>"ack",:name=>"Your Request for #{status} has been forwarded to the principal",:quantity=>0,:sender=>@message.sender)
    	if @forwarded_message.save
    	 	if @message.update_attribute(:sender,current_user_type)
    	 		flash[:notice]="Forwarded"
    	 	else
    	 		raise ActiveRecord::Rollback
    	 		flash[:error]="Ooops Something has gone wrong.. Try Again"
    	 	end
    	else
    		flash[:error]="Ooops Forwarding Failed"
        end
        redirect_to :back
    end


    def request_deny
    	@message=Message.find(params[:id])
    	status=@message.message_type=="writeoff" ? "WriteOff" : "Items"
 		@denial=Message.new(:department_id=>current_user.id,:lab_id=>@message.lab_id,:message_type=>"ack",:name=>"Your Request for #{status} has been Denied....",:quantity=>0,:sender=>@message.sender)
 		if @denial.save
 			if @message.destroy
 				flash[:notice]="Request Denied"
 			else
 				raise ActiveRecord::Rollback
 				flash[:error]="Ooops Something went wrong.. Try Again"
 		    end
 		else
 			flash[:error]="Ooops Denial Failed"
 	    end
 	    redirect_to :back
    end

    def acknowledgement_delete
    	@message=Message.find(params[:id])
    	unless @message.destroy
    		flash[:error]="Ooops Something has gone wrong"
    	end
    	redirect_to :back
    end

    def principal_writeoff
        @message=Message.find(params[:id])
        @acknowledgement=Message.new(:department_id=>@message.department_id,:lab_id=>@message.lab_id,:message_type=>"ack",:name=>"Your writeoff request has been Acknowledged by the principal.. Please wait some time...",:quantity=>0,:sender=>"Lab")
        @labstocks=Labstock.find(:all,:conditions=>{:lab_id=>@message.lab_id,:status=>"W"})
        @labstocks.each do |labstock|
            labstock.quantity=labstock.quantity-labstock.quantity_used
            quantity=labstock.quantity_used
            if labstock.quantity<0
                labstock.destroy
            else
                labstock.quantity_used=0
                labstock.status="P"
                labstock.save
            end
            labstock.office.quantity=labstock.office.quantity-quantity
            labstock.office.quantity_assigned=labstock.office.quantity_assigned-quantity
            if labstock.office.quantity<1
            	labstock.office.destroy
            else 
            	labstock.office.save
            end
        end
        flash[:error]="The Writeoff has been executed"
        @message.destroy
        @acknowledgement.save
        redirect_to root_url
    end

    def principal_deny
        @message=Message.find(params[:id])
        status= @message.message_type=="writeoff" ? "Writeoff" : @message.name
        @denial=Message.new(:department_id=>@message.department_id,:lab_id=>@message.lab_id,:message_type=>"ack",:name=>"Your Request for #{status} has been denied by the principal....",:quantity=>0,:sender=>@message.sender)
        if @denial.save
            if @message.destroy
                flash[:notice]="Request Denied"
            else
                raise ActiveRecord::Rollback
                flash[:error]="Ooops Something went wrong.. Try Again"
            end
        else
            flash[:error]="Denial Failed"
        end
        redirect_to root_url
    end

    def principal_acknowledge
        message=Message.find(params[:id])
        acknowledge=Message.new(:department_id=>message.department_id,:lab_id=>message.lab_id,:message_type=>"ack",:name=>"Your Request for #{message.name} has been acknowledged by the principal.",:quantity=>0,:sender=>"Lab")
        if acknowledge.save
            if message.destroy
                flash[:notice]="Acknowledged"
            else
                raise ActiveRecord::Rollback
                flash[:error]="Oops Something went wrong"
            end
        else
            flash[:error]="Acknowledging Failed"
        end
        redirect_to  :back
    end
end
