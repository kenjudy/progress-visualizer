require 'spec_helper'
require 'csv'
require 'json'

describe ExportBoardToCsv do

  let(:user_profile) { FactoryGirl.build(:user_profile)}
  let(:csv) { [] }

  context "export_current_sprint_board" do
    before { CSV.stub(:open).and_yield(csv) }

    after do
      VCR.use_cassette('lib/exportboardtocsv_writes_csv') do
        ExportBoardToCsv.export_current_sprint_board(user_profile, "tmp/eraseme.txt")
      end
    end

    it("writes csv") do
      expect(csv).to receive("<<").at_least(:once)
    end
  end
end
