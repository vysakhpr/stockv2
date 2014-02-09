class AdminController < ApplicationController
	include ApplicationHelper
  include DepartmentHelper
  helper_method :sort_column, :sort_direction
	before_filter :signed_in_admin, :only=>[:principal,:office,:sign_out]
	before_filter :sign_out_user, :only=>[:register,:create,:login, :sign_in]
  
	def register
		@admin=Admin.new
		
	end

	def create
		@admin=Admin.new(params[:admin])
		if @admin.save
			flash[:success]="Success"
			redirect_to root_url
		else
			flash[:error]="Oops Something has gone wrong"
			redirect_to :back
		end
	end

  def principal
  end

  def office
  	@offices = Office.order(sort_column + ' ' + sort_direction)
  end

  def login
  end

  def sign_in
  	admin=Admin.find_by_username(params[:username])
  		if admin && admin.authenticate(params[:password])
  			session[:admin_id]= admin.id
  			flash[:notice]="Welcome #{admin.role}"
  			if admin.role=="Principal"
  				redirect_to principal_path
  			else
  				redirect_to office_path
  			end
  		else
  			flash[:error]="Invalid credentials"
  			redirect_to :back
  		end
  end

  def sign_out
  	session[:admin_id]=nil
  	flash[:notice]="You have Successfully logged out"	
  	redirect_to root_url
  end

  
end
