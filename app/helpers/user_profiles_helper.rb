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
end