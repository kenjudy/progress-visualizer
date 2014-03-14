module UserProfilesHelper

  def display_keys(field)
    begin
      JSON.parse(field).values.join(",")
    rescue
      field || ""
    end
  end

  def request_token_url
    Rails.application.config.adapter_class.constantize.new(@profile).user_token_url
  end

  def options_for_day_of_week(selected_value)
    options_for_select([['Sunday', 0],['Monday', 1],['Tuesday', 2],['Wednesday', 3],['Thursday', 4],['Friday', 5], ['Saturday', 6]], selected_value )
  end

  def options_for_duration(selected_value)
    options_for_select([['One week', 7],['Two weeks', 14],['Three weeks', 21],['Four weeks', 28]], selected_value )
  end
end