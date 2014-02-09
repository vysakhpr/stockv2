module AdminHelper
	def admin_signed_in?
		!session[:admin_id].nil?
	end

end
