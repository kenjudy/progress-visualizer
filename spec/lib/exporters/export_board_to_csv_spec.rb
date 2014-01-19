require 'spec_helper'
require 'csv'
require 'json'

require_relative '../../models/trello/json_data'

module Exporters
  describe ExportBoardToCsv do
    include JsonData
    
    let(:card_json) { JSON.parse(card_json_string) }
    let(:card) { Trello::Card.new(card_json) }
    let(:csv) { [] }

    context "export_current_sprint_board" do
      after { ExportBoardToCsv.export_current_sprint_board("eraseme.txt") }
      it("calls run") { expect(ExportBoardToCsv).to receive(:run).with(Trello::Constants::CURRENT_SPRINT_BOARD_ID, "eraseme.txt") }
    end

    context "run" do

      before do
        Adapters::TrelloAdapter.stub(request_archived_cards: [card_json])
        CSV.stub(:open).and_yield(csv)
      end

      after { ExportBoardToCsv.run(Trello::Constants::CURRENT_SPRINT_BOARD_ID, "eraseme.txt") }

      it("creates board") { expect(Trello::Board).to receive(:new).with([card_json]).and_return(Trello::Board.new([card_json])) }

      it("writes csv") do
        expect(csv).to receive("<<").once.ordered.with(Trello::Card.array_attributes)
        expect(csv).to receive("<<").once.ordered.with(card.to_array)
      end
    end
  end
end