class ContactFormController < ApplicationController
  include UserProfileConcern
 
  before_filter :assign_user_profile, only: :new
 
  def new
    @contact_form = ContactForm.new
    @contact_form.type_of_inquiry = params['type_of_inquiry']
  end

  def create
    begin
      @contact_form = ContactForm.new(params[:contact_form])
      @contact_form.request = request
      if @contact_form.deliver
        flash.now[:notice] = "Thank you for your message! And for helping make <span class=\"brand\">Progress<span>Visualizer</span></span> better."
      else
        render :new
      end
    rescue ScriptError
      flash[:error] = 'Sorry, this message appears to be spam and was not delivered.'
    end
  end
end