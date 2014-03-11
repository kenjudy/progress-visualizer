class TodoStory
  include ActiveModel::Model

  attr_accessor :timestamp, :iteration, :type_of_work, :status, :story, :estimate, :user_story

end