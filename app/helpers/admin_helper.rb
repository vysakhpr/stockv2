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

end
