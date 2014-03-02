class ContactForm < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :type_of_inquiry

  attribute :message
  attribute :nickname,  :captcha  => true

  def headers
    {
      :subject => "ProgressVisualizer inquiry: #{type_of_inquiry}",
      :to => "progressvisualizer@judykat.com",
      :from => %("#{name}" <#{email}>)
    }
  end
end