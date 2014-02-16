module IterationConcern
  attr_accessor :adapter, :user_profile
  
  def adapter
    @adapter ||= Rails.application.config.adapter_class.constantize.new(user_profile)
  end
  
  def end_of_current_iteration
    Rails.application.config.iteration_end
  end
  
  def beginning_of_current_iteration
    Rails.application.config.iteration_start
  end
  
  def beginning_of_prior_iteration
    Rails.application.config.iteration_start - (Rails.application.config.iteration_end - Rails.application.config.iteration_start - 1)
  end
  
  def assign_user_profile
    @user_profile = params[:profile_id] ? current_user.user_profiles.find(params[:profile_id]) : session[:user_profile] ? current_user.user_profiles.find(session[:user_profile]) : current_user.default_profile
  end
  
end