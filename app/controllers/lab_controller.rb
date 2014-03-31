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
    @lab_messages=current_user.messages.order("created_at DESC")
    @messages=[]
    @lab_messages.each do |t|
      if t.message_type=="ack"
        @messages<<t
      end
    end
  end

  def password
  end

  def password_change
    lab=Lab.find(params[:id])
    if !(current_user_type=="HOD" or current_user.id==lab.id)
      flash[:error]="Access Denied"
      redirect_to root_url and return
    else 
      if current_user_type== "HOD"
        department=Department.find_by_username(current_user.username)
        unless department && department.authenticate(params[:current_password])
          flash[:error]="Authentication Error"
          redirect_to root_url and return
        end
      else
        lab=Lab.find_by_username(current_user.username)
        unless lab && lab.authenticate(params[:current_password])
          flash[:error]="Authentication Error" 
          redirect_to root_url and return
        end
      end
      if lab.update_attributes(:password=>params[:password],:password_confirmation=>params[:password_confirmation])
        flash[:notice]="Password for #{lab.name} Changed" 
        redirect_to root_url and return
      else
        flash[:error]=lab.errors.full_messages.to_sentence
        redirect_to root_url and return
      end
    end
  end

  def search
    unless params[:search].blank?
      @search=Office.search do 
        fulltext params[:search] do
          query_phrase_slop 1
          minimum_match 1
        end
        with(:department_id,current_user.department_id)
      end
    end
    @search_results=[]
    @labstocks=current_user.labstocks.all
    @labstocks.each do |labstock|
      @search.results.each do |result|
        if labstock.office_id==result.id
          @search_results<<labstock
        end
      end            
    end
    @search_results=@search_results.paginate(:page=>params[:page],:per_page=>30)
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
        flash[:error]=@labstock.errors.full_messages.to_sentence
       redirect_to :back
      end
    end
  end

  def update_used
  	@labstock=Labstock.find(params[:id])
  	if @labstock.quantity<params[:quantity_used].to_i
  		flash[:error]="Quantity over full size"
  	else
    	@labstock.quantity_used=params[:quantity_used].to_i
  		if @labstock.save
  			flash[:success]="Saved"
 			else
 				flash[:error]=@labstock.errors.full_messages.to_sentence
 			end
  	end
  	redirect_to :back
  end


  def login
  end

  def register
  	@lab=Lab.new
  end
  
  def create

		@lab=current_user.labs.build(params[:lab])
		if @lab.save
			user=User.new(:username=>params[:lab][:username],:role=>"Lab")
      if user.save
       flash[:success]="Added New Lab Successfully"
       redirect_to root_url
      else
        raise ActiveRecord::Rollback
        flash[:error]=user.errors.full_messages.to_sentence
        redirect_to :back
      end
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
