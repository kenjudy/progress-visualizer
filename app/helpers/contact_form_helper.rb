module ContactFormHelper

  def options_for_type_of_inquiry(selected_value)
    options_for_select(["Help", "Question", "Suggestion", "Other"], selected_value)
  end
end