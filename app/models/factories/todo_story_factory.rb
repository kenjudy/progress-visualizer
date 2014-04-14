module Factories
  class TodoStoryFactory
    include TablesModelConcern

    def refresh
      board = ProgressVisualizerTrello::Board.find_current_sprint_board(user_profile)
      collate(board,
              user_profile.labels_types_of_work.split(","),
              JSON.parse(user_profile.backlog_lists).keys)
    end
  end
end