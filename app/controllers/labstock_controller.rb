class LabstockController < ApplicationController
  def new
  	@office=Office.find(params[:id])
  	@labstock=Labstock.new
  end

  def create
  	@labstock=Labstock.new(params[:labstock])
  	unless @labstock.quantity.nil?
  		if (@labstock.office.quantity-@labstock.office.quantity_assigned) < @labstock.quantity
  			flash[:error]="Quantity over full size"
  			redirect_to :back, method: :post
  		elsif @labstock.save
  			flash[:info]="Successively Assigned"
        diff=@labstock.office.quantity_assigned+@labstock.quantity
        @labstock.office.update_attribute(:quantity_assigned,diff)
  			redirect_to root_url
  		end	
  	else
  		flash[:error] = @labstock.errors.full_messages.to_sentence
  		redirect_to :back
   	end
  	
  end

  def show
     @office=Office.find(params[:id])
     @labstocks=@office.labstocks
  end

  def delete
  end
end
