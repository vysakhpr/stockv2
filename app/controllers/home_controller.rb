class HomeController < ApplicationController
  include ApplicationHelper
  include AdminHelper
  include DepartmentHelper
  include LabHelper
  def index
  	if signed_in?
  		flash.keep
  		if current_user_type=="Admin"
  			redirect_to "/#{current_admin_type.downcase}"

  		elsif current_user_type=="HOD"
        redirect_to department_index_path
  		elsif current_user_type=="Lab"
        redirect_to lab_index_path
  		end
  	end
  end

  def sign_in
    user=User.find_by_username(params[:username])
    if !(user.nil?)
      if user.role=="Admin"
        admin=Admin.find_by_username(params[:username])
        if admin && admin.authenticate(params[:password])
          session[:admin_id]= admin.id
          flash[:notice]="Welcome #{admin.role}"
          if admin.role=="Principal"
            redirect_to principal_path and return
          else
            redirect_to office_path and return
          end
        else
          flash[:error]="Invalid credentials"
          redirect_to :back and return
        end
      elsif user.role=="HOD"
      	department=Department.find_by_username(params[:username])
  				if department && department.authenticate(params[:password])
  					session[:department_id]= department.id
  					flash[:notice]="Welcome #{department.name} Department Head"
  					redirect_to root_url and return
  				else
  					flash[:error]="Invalid credentials"
  					redirect_to :back and return
  				end
      elsif user.role=="Lab"
      		lab=Lab.find_by_username(params[:username])
  				if lab && lab.authenticate(params[:password])
  					session[:lab_id]= lab.id
  					flash[:notice]="Welcome #{lab.name} In Charge"
		  			redirect_to root_url and return
  				else
  					flash[:error]="Invalid credentials"
		  			redirect_to :back and return
  				end
      end
    else
      flash[:error]="Invalid Credentials"
      redirect_to root_url and return
    end
  end
end
