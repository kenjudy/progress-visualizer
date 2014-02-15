module UserProfilesHelper
  
  def display_keys(field)
    begin
      JSON.parse(field).values.join(",")
    rescue
      field
    end
  end
  
end