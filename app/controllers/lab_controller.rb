class LabController < ApplicationController
	include ApplicationHelper
	include DepartmentHelper
	include AdminHelper
	include LabHelper

	before_filter :signed_in_lab, :only=>[:index,:sign_out]
  	before_filter :signed_in_hod, :only=>[:create,:register]
	before_filter :sign_out_user, :only=>[:login, :sign_in]

  def index
    @labstocks_perfects=current_user.labstocks.find(:all,:conditions=>{status:"P"})
    @labstocks_repairs=current_user.labstocks.find(:all,:conditions=>{status:"R"})
    @labstocks_irrepairs=current_user.labstocks.find(:all,:conditions=>{status:"I"})
  end

  def update
    @labstock=Labstock.find(params[:id])
    if params[:status].blank?
      flash[:notice]="Select a value for status"
      redirect_to :back
    else

      if @labstock.update_attribute(:status,params[:status])
        flash[:notice]="Saved"
        redirect_to :back
      else
        flash[:notice]=@labstock.errors.full_messages.to_sentence
       redirect_to :back
      end
    end


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
