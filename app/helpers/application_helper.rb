module ApplicationHelper
	def signed_in?
		(admin_signed_in?||hod_signed_in?)# || lab_signed_in?
	end	

	def signed_in_user
		unless signed_in?
			flash[:notice]="Please Sign In"
			redirect_to root_url
		end
	end

	def sign_out_user
		if signed_in?
			flash[:notice]="Please Logout to Continue"
			redirect_to root_url
		end
	end

	def current_user
		if admin_signed_in?
		  Admin.find(session[:admin_id])
		elsif hod_signed_in?
		  Department.find(session[:department_id])
		end	
	end

	def current_user_type
		if signed_in?
			if admin_signed_in?
				"Admin"
			elsif hod_signed_in?
				"HOD"
			#else
			#	"Lab"
			end
		end
	end

	def sortable(column, title = nil)
    	title ||= column.titleize
    	if column == sort_column
        	 if sort_direction == "asc" 
           	 css_class= "icon-chevron-up" 
         	else
        	css_class= "icon-chevron-down"
         	end
    	else
    		css_class=nil
    	end    
    	direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    	link_to title, {:sort => column, :direction => direction},{:class => css_class}
  	end


  	
      def sort_column
          Office.column_names.include?(params[:sort]) ? params[:sort] : "date"
      end

      def sort_direction
          %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
      end

  	
end
