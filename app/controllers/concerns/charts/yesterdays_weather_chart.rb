module Charts
  class YesterdaysWeatherChart
    extend ActiveSupport::Concern
    include ::IterationConcern
    
    attr_accessor :label, :weeks
    
    def initialize(user_profile, options)
      @user_profile = user_profile
      @weeks = options[:weeks] || 3
      @label = options[:label] || :estimate
    end
    
    def types_of_work 
      adapter.current_sprint_board_properties[:labels_types_of_work]
    end
  end
end