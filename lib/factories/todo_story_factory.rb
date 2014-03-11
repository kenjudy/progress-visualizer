module Factories
  class TodoStoryFactory
    include Tables::TablesConcern
 
    def refresh
      board = Adapters::BaseAdapter.build_adapter(user_profile).request_board(user_profile.current_sprint_board_id)
      collate(board,
              user_profile.labels_types_of_work.split(","), 
              JSON.parse(user_profile.backlog_lists).keys)
    end
  end
end