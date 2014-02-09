module AdminHelper
	def admin_signed_in?
		!session[:admin_id].nil?
	end

	def current_admin_type
		unless session[:admin_id].nil?
			admin=Admin.find(session[:admin_id])
			admin.role
		end
	end

	def signed_in_admin
		unless admin_signed_in?
			flash[:notice]="Access Denied"
			redirect_to root_url
		end
	end

	def sign_out_admin
		if admin_signed_in?
			flash[:notice]="Please Logout to Continue"
			redirect_to root_url
		end
	end

end
