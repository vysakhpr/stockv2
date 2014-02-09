class OfficeController < ApplicationController
before_filter :signed_in_admin, :except=>:show
  def new
  	
  	@office = Office.new
  	@departments=Department.all
  end

  def show
     @office=Office.find(params[:id])
     @labs=@office.labs
  end

  def create
  	@office=Office.create(params[:office])
  	if @office.save
  		flash[:notice]="Saved"
  		redirect_to root_url
    else
    	flash[:error] = @office.errors.full_messages.to_sentence
    	redirect_to office_new_path
    end

  end

  def delete
  end
end
