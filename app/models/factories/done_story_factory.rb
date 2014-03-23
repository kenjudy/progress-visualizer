module Factories
  class DoneStoryFactory
    include TablesModelConcern

    def refresh
      board = BaseAdapter.build_adapter(user_profile).request_board(user_profile.current_sprint_board_id)
      collated_data = collate(board,
                              user_profile.labels_types_of_work.split(","),
                              JSON.parse(user_profile.done_lists).keys)
      update_done_stories_for(collated_data)
    end

    def update_done_stories_for(collated_data)
      collated_data[:lists].keys.each do |type_of_work|
        collated_data[:lists][type_of_work][:cards].each do |card|
          DoneStory.create_or_update_from(@user_profile, card, type_of_work, user_profile.beginning_of_current_iteration)
        end
      end
      return collated_data
    end

    def for_iteration(iteration)
      done_stories = user_profile.done_stories.where('timestamp = ? and status in (?)', iteration, JSON.parse(user_profile.done_lists).keys)
      collated_data = collate(done_stories,
                              user_profile.labels_types_of_work.split(","),
                              JSON.parse(user_profile.done_lists).keys,
                              iteration)
    end
  end
end