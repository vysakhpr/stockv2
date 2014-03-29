class LabstockController < ApplicationController
  def new
  	@office=Office.find(params[:id])
  	@labstock=Labstock.new
  end

  def create
    @labstock_exist=Labstock.find_by_office_id(params[:labstock][:office_id])
    unless @labstock_exist.nil?
      unless @labstock_exist.quantity.nil?
        if (@labstock_exist.office.quantity-@labstock_exist.office.quantity_assigned) < params[:labstock][:quantity].to_i
          flash[:error]="Quantity over full size"
          redirect_to root_url
        else 
          @labstock_exist.quantity=@labstock_exist.quantity+params[:labstock][:quantity].to_i
          if @labstock_exist.save
            flash[:info]="Successively Assigned"
            diff=@labstock_exist.office.quantity_assigned+params[:labstock][:quantity].to_i
            @labstock_exist.office.update_attribute(:quantity_assigned,diff)
            redirect_to root_url
          else
            flash[:error]=@labstock_exist.errors.full_messages.to_sentence
            redirect_to root_url
          end
        end           
      else
        flash[:error] = "Quantity Should have some value"
        redirect_to root_url
      end
    else
  	 @labstock=Labstock.new(params[:labstock])
  	 unless @labstock.quantity.nil?
  	 	  if (@labstock.office.quantity-@labstock.office.quantity_assigned) < @labstock.quantity
  			  flash[:error]="Quantity over full size"
  			  redirect_to root_url
  		  elsif @labstock.save
  			  flash[:info]="Successively Assigned"
          diff=@labstock.office.quantity_assigned+@labstock.quantity
          @labstock.office.update_attribute(:quantity_assigned,diff)
  			  redirect_to root_url
        else
          flash[:error] = @labstock.errors.full_messages.to_sentence
          redirect_to root_url
  		  end	
  	  else
  		  flash[:error] = "Quantity is Nil"
  		  redirect_to root_url
   	  end
    end
  end

  def show
     @office=Office.find(params[:id])
     @labstocks=@office.labstocks
  end

  def transfer
    
  end

  def writeoff
    @labstocks=Labstock.find(:all,:conditions=>{:lab_id=>params[:id],:status=>"W"})
    @message=Message.find(:first,:conditions=>{:lab_id=>params[:id],:message_type=>"writeoff"})
  end

  def delete
  end
end
