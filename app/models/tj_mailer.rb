class TjMailer < ActionMailer::Base
  

  def sent(sent_at = Time.now)
    subject    'TjMailer#sent'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
