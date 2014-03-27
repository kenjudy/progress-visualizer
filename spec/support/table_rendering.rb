shared_examples "a table" do

  # it { subject.save_screenshot("tmp/screenshots/#{table_title.downcase.gsub(/[^0-9A-Za-z.\-]/, '_')}_screenshot.png", full: true) }

  it { should have_content("#{table_title} #{iteration.strftime("%B %e, %Y")} - #{user_profile.end_of_current_iteration.strftime("%B %e, %Y")}") }
    
  context "story counts" do
    it { subject.find("tr.totals th.count")}
  end
  
  context "estimate sum" do
    it { subject.find("tr.totals th.estimate") }
  end
  
  context "points" do
    it { subject.all("tr.story td.estimate").count > 1 }
  end
  
  context "story name" do
    it { subject.all("tr.story td.name").count > 1 }
  end
  
end
