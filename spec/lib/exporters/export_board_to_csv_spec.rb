require 'spec_helper'
require 'csv'
require 'json'

module Exporters
  describe ExportBoardToCsv do
    include ProgressVisualizerTrello::JsonData

    let(:list_data) { example_list_data }
    let(:list) { ProgressVisualizerTrello::Card.new(list_data) }
    let(:card_data) { example_card_data }
    let(:card) { ProgressVisualizerTrello::Card.new(card_data) }
    let(:csv) { [] }

    context "export_current_sprint_board" do
      after { ExportBoardToCsv.export_current_sprint_board("eraseme.txt") }
      it("calls run") { expect(ExportBoardToCsv).to receive(:run).with(Rails.application.config.current_sprint_board[:id], "eraseme.txt") }
    end

    context "run" do

      before do
        allow_any_instance_of(Adapters::TrelloAdapter).to receive(:request_board).and_return(ProgressVisualizerTrello::Board.new(cards: [card_data, card_data], lists: [list_data]))
        CSV.stub(:open).and_yield(csv)
        card.list = list
      end

      after { ExportBoardToCsv.run(Rails.application.config.current_sprint_board[:id], "tmp/eraseme.txt") }

      it("writes csv") do
        expect(csv).to receive("<<").once.ordered.with(ProgressVisualizerTrello::Card.array_attributes)
        expect(csv).to receive("<<").once.ordered.with(card.to_array)
        expect(csv).to receive("<<").once.ordered.with(card.to_array)
      end
    end
  end
end