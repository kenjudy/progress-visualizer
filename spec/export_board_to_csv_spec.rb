require 'csv'

require_relative '../app/export_board_to_csv'
require_relative '../app/constants'
require_relative 'json_data'

include JsonData

include TrelloReport::Constants

describe TrelloReport::ExportBoardToCsv do
  let(:uri) { double(URI, read: "[{}]" ) }
  before { URI.stub(parse: uri) }

  context "form request URL" do
    it { expect(TrelloReport::ExportBoardToCsv.form_request_url(@@current_sprint_board_id)).to eql("https://api.trello.com/1/boards/#{@@current_sprint_board_id}/cards/closed?key=#{@@user_key}&token=#{@@readonly_token}")}
  end

  context "request json" do
    subject { TrelloReport::ExportBoardToCsv.request_json(@@current_sprint_board_id) }

    it { should == [{}] }
    
  end
  
  context "run" do
    let(:raw_json) { "[#{card_json_string}]" }
    let(:uri) { double(URI, read: raw_json ) }
    let(:csv) { [] }
    let(:card_json) { JSON.parse(card_json_string) }
    let(:card) { TrelloReport::Card.new(card_json) }

    before { CSV.stub(:open).and_yield(csv) }
    
    after { TrelloReport::ExportBoardToCsv.run(@@current_sprint_board_id, "eraseme.txt") }
    
    it("creates board") { expect(TrelloReport::Board).to receive(:new).with(JSON.parse(raw_json)) }
    
    it("writes csv") { expect(csv).to receive("<<").twice.with(TrelloReport::Card.array_attributes, card.to_array) }
  end
  
  context "export_current_sprint_board" do
    after { TrelloReport::ExportBoardToCsv.export_current_sprint_board("eraseme.txt") }
    it("calls run") { expect(TrelloReport::ExportBoardToCsv).to receive(:run).with(@@current_sprint_board_id) }

  end
end