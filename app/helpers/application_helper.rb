module ApplicationHelper
	def signed_in?
		admin_signed_in? #|| hod_signed_in? || lab_signed_in?
	end	

	def signed_in_user?
		unless signed_in?
			flash[:notice]="Please Sign In"
			redirect_to root_url
		end
	end

	def current_user
		if admin_signed_in?
		  Admin.find(session[:admin_id])
		end	
	end
end
