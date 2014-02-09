module DepartmentHelper
	def hod_signed_in?
		!session[:department_id].nil?
	end

	def signed_in_hod
		unless hod_signed_in?
			flash[:notice]="Access Denied"
			redirect_to root_url
		end
	end

	def sign_out_hod
		if hod_signed_in?
			flash[:notice]="Please Logout to Continue"
			redirect_to root_url
		end
	end
end
