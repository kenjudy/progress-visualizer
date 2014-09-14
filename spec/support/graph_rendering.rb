shared_examples "a graph" do

  it { subject.find("#{chart_id} svg");subject.save_screenshot("tmp/screenshots/#{chart_id}_screenshot.png", full: true) }

  it("renders svg with plot points") do
    subject.find("#{chart_id} svg")
    expect(subject.all("#{chart_id} svg g").count).to be > 1
  end
  
end
