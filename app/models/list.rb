require 'json'

class List < TrelloObject

  attr_reader :id, :name, :id_board

  def assign_attributes(data)
    @id = @data["id"]
    @name = @data["name"]
    @id_board = @data["idBoard"]
  end

  def self.find_by(args)
    args[:board_id] ||= args[:user_profile].current_sprint_board_id_short
    list_data = BaseAdapter.build_adapter(args[:user_profile]).request_lists_data(args[:board_id])
    list_data.map{ |data| List.new(data) }
  end

end
