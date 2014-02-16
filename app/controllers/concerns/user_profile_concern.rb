module UserProfileConcern
  attr_accessor :user_profile

  define_method :assign_user_profile do
    return @user_profile if @user_profile
    self.params ||= {}
    self.session ||= {}
    self.current_user ||= nil
    if self.params && self.params[:profile_id] 
      @user_profile = self.current_user.user_profiles.find(params[:profile_id])
    elsif session[:user_profile] 
      @user_profile = self.current_user.user_profiles.find(session[:user_profile])
    elsif current_user
      @user_profile = self.current_user.default_profile
    end
    return @user_profile
  end
end