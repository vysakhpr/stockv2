class AdminController < ApplicationController
	include ApplicationHelper
  include DepartmentHelper
  include LabHelper
  helper_method :sort_column, :sort_direction
	before_filter :signed_in_admin, :only=>[:principal,:office,:sign_out]
	before_filter :sign_out_user, :only=>[:register,:create,:login, :sign_in]
  
	def register
		@admin=Admin.new
		
	end

	def create
		@admin=Admin.new(params[:admin])
		if @admin.save
      user=User.new(:username=>params[:admin][:username],:role=>"Admin")
      if user.save
			 flash[:success]="Success"
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

  def password
  end

  def password_change
    admin=Admin.find(params[:id])
    if !(current_user_type=="Admin" and current_user.id==admin.id)
      flash[:error]="Access Denied"
      redirect_to root_url and return
    else 
      admin=Admin.find_by_username(current_user.username)
      unless admin && admin.authenticate(params[:current_password])
        flash[:error]="Authentication Error"
        redirect_to root_url and return
      end
      if admin.update_attributes(:password=>params[:password],:password_confirmation=>params[:password_confirmation])
        flash[:notice]="Password for #{admin.role} Changed" 
        redirect_to root_url and return
      else
        flash[:error]=admin.errors.full_messages.to_sentence
        redirect_to root_url and return
      end
    end
  end


  def principal
    unless params[:search].blank?
      @search=Office.search do
        fulltext params[:search] do
          query_phrase_slop 1
          minimum_match 1
        end
        paginate :page=>params[:page],:per_page=>30
      end
    end
    @departments=Department.all
    @writeoff_messages=Message.find(:all,:conditions=>{sender:"HOD",message_type:"writeoff"})
    @needitems_messages=Message.find(:all,:conditions=>{sender:"HOD",message_type:"request"})
    @offices = Office.order(sort_column + ' ' + sort_direction)
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

  private

  def sort_column
          Office.column_names.include?(params[:sort]) ? params[:sort] : "date"
      end

      def sort_direction
          %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
      end


  
end
