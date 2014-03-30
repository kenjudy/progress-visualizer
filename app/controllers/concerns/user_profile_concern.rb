module UserProfileConcern
  attr_accessor :user_profile

  def assign_user_profile
    #profile only exists in context of authenticated user
    return unless self.respond_to?("current_user") && self.current_user

    if set_profile
      self.session[:profile_id] = user_profile.id
    else
      flash.notice = flash_notice
      redirect_to user_profiles_path unless request.fullpath.include?(user_profiles_path)
    end
    
    return user_profile
  end
  
  private
  
  def flash_notice
    if notice && notice.include?("Now add a profile")
      flash.notice
    else
      "#{flash.notice} Now add a profile. <a href='#{new_user_profile_path}' class='btn btn-default'>Add</a>"
    end
  end
  
  def set_profile
    begin
      @user_profile = profile_from_params || profile_from_session
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error(e.message)
    end
    
    @user_profile = @user_profile || profile_from_current_user_default || profile_from_first_of_user
  end
  
  def profile_from_params
    profile_id = self.params[:profile_id] if self.respond_to?("params")
    
    return unless profile_id
      
    user_profile = self.current_user.user_profiles.find(profile_id)
    self.session[:profile_id] = user_profile.id if user_profile
    user_profile
  end
  
  def profile_from_session
    if self.session[:profile_id]
      user_profile = self.current_user.user_profiles.find(self.session[:profile_id])
      user_profile
    end
  end
  
  def profile_from_current_user_default
    self.current_user.default_profile
  end
  
  def profile_from_first_of_user
    self.current_user.user_profiles.first
  end
end