module ApplicationHelper
	def signed_in?
		admin_signed_in? #|| hod_signed_in? || lab_signed_in?
	end	
end
