class BaseAdapter
  attr_accessor :user_profile

  def initialize(user_profile)
    @user_profile = user_profile
  end

  def self.build_adapter(user_profile)
    Rails.application.config.adapter_class.constantize.new(user_profile)
  end

end
