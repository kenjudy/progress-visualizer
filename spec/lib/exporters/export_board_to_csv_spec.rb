require 'spec_helper'
require 'csv'
require 'json'

module Exporters
  describe ExportBoardToCsv do
    include Trello::JsonData

    let(:list_data) { example_list_data }
    let(:list) { Trello::Card.new(list_data) }
    let(:card_data) { example_card_data }
    let(:card) { Trello::Card.new(card_data) }
    let(:csv) { [] }

    context "export_current_sprint_board" do
      after { ExportBoardToCsv.export_current_sprint_board("eraseme.txt") }
      it("calls run") { expect(ExportBoardToCsv).to receive(:run).with(Constants::CONFIG[:current_sprint_board][:id], "eraseme.txt") }
    end

    context "run" do

      before do
        Adapters::TrelloAdapter.stub(request_board: Trello::Board.new(cards: [card_data, card_data], lists: [list_data]))
        CSV.stub(:open).and_yield(csv)
        card.list = list
      end

      after { ExportBoardToCsv.run(Constants::CONFIG[:current_sprint_board][:id], "tmp/eraseme.txt") }

      it("writes csv") do
        expect(csv).to receive("<<").once.ordered.with(Trello::Card.array_attributes)
        expect(csv).to receive("<<").once.ordered.with(card.to_array)
        expect(csv).to receive("<<").once.ordered.with(card.to_array)
      end
    end
  end
end