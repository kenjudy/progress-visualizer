module UserProfileConcern
  attr_accessor :user_profile

  def assign_user_profile
    return unless self.respond_to?("current_user") && self.current_user #profile only exists in context of authenticated user
    
    if self.respond_to?("params") && self.params[:profile_id]
      @user_profile = self.current_user.user_profiles.find(self.params[:profile_id])
      self.session[:profile_id] = @user_profile.id if @user_profile
    elsif self.session[:profile_id]
      @user_profile = self.current_user.user_profiles.find(self.session[:profile_id])
    else
      @user_profile = self.current_user.default_profile
      self.session[:profile_id] = @user_profile.id if @user_profile
    end
    return @user_profile
  end
end