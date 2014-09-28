module ContactFormHelper

  def options_for_type_of_inquiry(selected_value)
    options_for_select(["Help", "Question", "Suggestion", "Other"], selected_value)
  end
  
  def user_name
    user_profile && user_profile.user ? user_profile.user.name : nil
  end
  
  def user_email
    user_profile && user_profile.user ? user_profile.user.email : nil
  end
end