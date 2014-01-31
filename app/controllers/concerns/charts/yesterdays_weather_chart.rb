module Charts
  class YesterdaysWeatherChart
    extend ActiveSupport::Concern
    extend ::BaseVisualization
    include ::BaseVisualization
    attr_accessor :label, :weeks
    
    def initialize(options)
      @weeks = options[:weeks] || 3
      @label = options[:label] || :estimate
    end
    
    def types_of_work 
      adapter.current_sprint_board_properties[:labels_types_of_work]
    end
  end
end