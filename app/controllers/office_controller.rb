class OfficeController < ApplicationController

before_filter :signed_in_admin, :except=>:show
  def new  	
  	@office = Office.new
  	@departments=Department.all
  end

  def show
     @office=Office.find(params[:id])
     @labstocks=@office.labstocks
  end

  def create
    params[:office][:voucher_no]=params[:office][:voucher_no]+"~#{Time.now}"
  	@office=Office.create(params[:office])
  	if @office.save
  		flash[:notice]="Saved"
  		redirect_to root_url
    else
    	flash[:error] = @office.errors.full_messages.to_sentence
    	redirect_to office_new_path
    end

  end
end
