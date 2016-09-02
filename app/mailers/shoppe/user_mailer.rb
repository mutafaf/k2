module Shoppe
  class UserMailer < ActionMailer::Base
    def new_password(user)
      @user = user
      mail from: Shoppe.settings.outbound_email_address, to: user.email_address, subject: 'Your new Shoppe password'
    end

    def contact_us(contact_details)
      @contact = contact_details[:user]
      mail to: Shoppe.settings.outbound_email_address,:from=>@contact[:email],:subject=>"Contact Us [Borjan]"
    end
  end
end
