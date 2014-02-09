module LabHelper
	def lab_signed_in?
		!session[:lab_id].nil?
	end

	def signed_in_lab
		unless lab_signed_in?
			flash[:notice]="Access Denied"
			redirect_to root_url
		end
	end

	def sign_out_lab
		if lab_signed_in?
			flash[:notice]="Please Logout to Continue"
			redirect_to root_url
		end
	end
end
