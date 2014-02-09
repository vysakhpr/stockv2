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
end
