class LabController < ApplicationController
	include ApplicationHelper
	include DepartmentHelper
	include AdminHelper
	include LabHelper

	before_filter :signed_in_lab, :only=>[:index,:sign_out]
  	before_filter :signed_in_hod, :only=>[:create,:register]
	before_filter :sign_out_user, :only=>[:login, :sign_in]

  def index
  end

  def login
  end

  def register
  	@lab=Lab.new
  end
  
  def create
		@lab=current_user.labs.build(params[:lab])
		if @lab.save
			flash[:success]="Added New lab Successfully"
			redirect_to root_url
		else
			flash[:error]="Oops Something has gone wrong"
			redirect_to :back
		end
	end

	def sign_in
  		lab=Lab.find_by_username(params[:username])
  		if lab && lab.authenticate(params[:password])
  			session[:lab_id]= lab.id
  			flash[:notice]="Welcome #{lab.name} In Charge"
  			redirect_to root_url
  		else
  			flash[:error]="Invalid credentials"
  			redirect_to :back
  		end
  end

  def sign_out
  	session[:lab_id]=nil
  	flash[:notice]="You have Successfully logged out"	
  	redirect_to root_url
  end

end
