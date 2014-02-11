class DepartmentController < ApplicationController
	include ApplicationHelper
	include DepartmentHelper
  include AdminHelper
  include LabHelper

  before_filter :signed_in_hod, :only=>[:index,:sign_out]
  before_filter :signed_in_admin, :only=>[:create,:register]
	before_filter :sign_out_user, :only=>[:login, :sign_in]
  

  def index
    @labs=current_user.labs
    @offices=current_user.offices.order(sort_column + ' ' + sort_direction)
    @hods=[]
    @offices.each do |t|
      unless t.labstocks.exists?
        @hods<<t
      end
      if (t.labstocks.exists?)&&(t.quantity_assigned<t.quantity)
        @hods<<t
      end  
    end  
  end

  def login
  end

  def register
  	@department=Department.new
  end
  
  def create
		@department=Department.new(params[:department])
		if @department.save
			flash[:success]="Added New Department Successfully"
			redirect_to root_url
		else
			flash[:error]="Oops Something has gone wrong"
			redirect_to :back
		end
	end

	def sign_in
  	department=Department.find_by_username(params[:username])
  		if department && department.authenticate(params[:password])
  			session[:department_id]= department.id
  			flash[:notice]="Welcome #{department.name} Department Head"
  			redirect_to root_url
  		else
  			flash[:error]="Invalid credentials"
  			redirect_to :back
  		end
  end

  def sign_out
  	session[:department_id]=nil
  	flash[:notice]="You have Successfully logged out"	
  	redirect_to root_url
  end


end
