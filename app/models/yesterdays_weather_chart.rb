class YesterdaysWeatherChart
  include ActiveModel::Model

  attr_accessor :label, :weeks

  def initialize(user_profiles, options)
    @user_profiles = user_profiles
    @weeks = options[:weeks] || 3
    @label = options[:label] || :estimate
  end

  def types_of_work
    YesterdaysWeatherChart.types_of_work(@user_profiles)
  end
  
  def self.types_of_work(user_profiles)
    user_profiles.map(&:labels_types_of_work).join(',').split(',').delete_if{|l| l.blank?}.uniq << nil
  end
end