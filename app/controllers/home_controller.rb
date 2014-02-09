class HomeController < ApplicationController
  include ApplicationHelper
  include AdminHelper
  include DepartmentHelper
  def index
  	if signed_in?
  		flash.keep
  		if current_user_type=="Admin"
  			redirect_to "/#{current_admin_type.downcase}"

  		elsif current_user_type=="HOD"
        redirect_to department_index_path
  		#else

  		end
  	end
  end
end
