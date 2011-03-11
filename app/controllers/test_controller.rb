class TestController < ApplicationController
	def create_auto_mail
		UserMailer.deliver_auto_mail
		redirect_to :back
		#email = UserMailer.create_auto_mail
		#render(:text => "<pre>" + email.encoded + "</pre>")
	end	

	def create_mail
		UserMailer.deliver_notice
		email = UserMailer.create_notice
		render(:text => "<pre>" + email.encoded + "</pre>")
	end

	def create_mail2
		UserMailer.deliver_notice2
		email = UserMailer.create_notice2
		render(:text => "<pre>" + email.encoded + "</pre>")
	end	
	
end		