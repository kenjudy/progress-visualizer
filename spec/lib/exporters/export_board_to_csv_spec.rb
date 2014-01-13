require 'spec_helper'
require 'csv'

require_relative '../../models/trello/json_data'

module Exporters
  describe ExportBoardToCsv do
    include JsonData
  
    let(:uri) { double(URI, read: "[{}]" ) }
    before { URI.stub(parse: uri) }

    context "form request URL" do
      it { expect(ExportBoardToCsv.form_request_url(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID)).to eql("https://api.trello.com/1/boards/#{TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID}/cards/closed?key=#{TrelloReport::Constants::USER_KEY}&token=#{TrelloReport::Constants::READONLY_TOKEN}")}
    end

    context "request json" do
      subject { ExportBoardToCsv.request_json(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID) }

      it { should == [{}] }
  
    end

    context "run" do
      let(:raw_json) { "[#{card_json_string}]" }
      let(:uri) { double(URI, read: raw_json ) }
      let(:csv) { [] }
      let(:card_json) { JSON.parse(card_json_string) }
      let(:card) { Trello::Card.new(card_json) }

      before { CSV.stub(:open).and_yield(csv) }
  
      after { ExportBoardToCsv.run(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID, "eraseme.txt") }
  
      it("creates board") { expect(Trello::Board).to receive(:new).with(JSON.parse(raw_json)).and_return(Trello::Board.new(JSON.parse(raw_json))) }
  
      it("writes csv") { expect(csv).to receive("<<").twice.with(Trello::Card.array_attributes, card.to_array) }
    end

    context "export_current_sprint_board" do
      after { ExportBoardToCsv.export_current_sprint_board("eraseme.txt") }
      it("calls run") { expect(ExportBoardToCsv).to receive(:run).with(TrelloReport::Constants::CURRENT_SPRINT_BOARD_ID, "eraseme.txt") }

    end
  end
end