class HomeController < ApplicationController
  include ApplicationHelper
  include AdminHelper
  def index
  	if signed_in?
  		if current_user_type=="Admin"
  			redirect_to "/#{current_admin_type.downcase}"

  		#elsif current_user_type=="HOD"

  		#else

  		end
  	end
  end
end
