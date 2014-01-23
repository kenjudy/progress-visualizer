require 'spec_helper'
require 'csv'
require 'json'

module Exporters
  describe ExportBoardToCsv do
    include Trello::JsonData
    
    let(:card_data) { example_card_data }
    let(:card) { Trello::Card.new(card_data) }
    let(:csv) { [] }

    context "export_current_sprint_board" do
      after { ExportBoardToCsv.export_current_sprint_board("eraseme.txt") }
      it("calls run") { expect(ExportBoardToCsv).to receive(:run).with(Trello::Constants::CURRENT_SPRINT_BOARD_ID, "eraseme.txt") }
    end

    context "run" do

      before do
        Adapters::TrelloAdapter.stub(request_archived_cards: [card_data])
        Adapters::TrelloAdapter.stub(request_cards: [card_data])
        CSV.stub(:open).and_yield(csv)
      end

      after { ExportBoardToCsv.run(Trello::Constants::CURRENT_SPRINT_BOARD_ID, "eraseme.txt") }

      it("creates board") { expect(Trello::Board).to receive(:new).with([card_data]).and_return(Trello::Board.new([card_data])) }

      it("writes csv") do
        expect(csv).to receive("<<").once.ordered.with(Trello::Card.array_attributes)
        expect(csv).to receive("<<").once.ordered.with(card.to_array)
        expect(csv).to receive("<<").once.ordered.with(card.to_array)
      end
    end
  end
end