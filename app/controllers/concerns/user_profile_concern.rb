module UserProfileConcern
  attr_accessor :user_profile

  def assign_user_profile
    return unless self.respond_to?("current_user") && self.current_user #profile only exists in context of authenticated user

    begin
      profile_from_params || profile_from_session
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error(e.message)
    end

    unless @user_profile
      @user_profile = self.current_user.default_profile || self.current_user.user_profiles.first
      self.session[:profile_id] = @user_profile.id if @user_profile
    end

    unless @user_profile
      flash.notice = "#{flash.notice} Please create a profile associating your account to a trello board. <a href='#{new_user_profile_path}' class='btn btn-default'>Add</a>" unless (flash.notice && flash.notice.include?("Please create a profile associating"))
      redirect_to user_profiles_path unless request.fullpath.include?(user_profiles_path)
    end
    return @user_profile
  end
  
  private
  
  def profile_from_params
    if self.respond_to?("params") && self.params[:profile_id]
      @user_profile = self.current_user.user_profiles.find(self.params[:profile_id])
      self.session[:profile_id] = @user_profile.id if @user_profile
      @user_profile
    end
  end
  
  def profile_from_session
    if self.session[:profile_id]
      @user_profile = self.current_user.user_profiles.find(self.session[:profile_id])
      @user_profile
    end
  end
end