shared_examples "a paginatable visualization" do

  context "pagination" do
    before do
      FactoryGirl.create(:done_story, user_profile: user_profile, iteration: iteration.strftime("%Y-%m-%d"))
      FactoryGirl.create(:done_story, user_profile: user_profile, iteration: (iteration - user_profile.duration.days).strftime("%Y-%m-%d"))
    end
    
    it("previous/next") do
      subject.find(".pager .previous")
      click_link("Older")
      subject.find(".pager .next")
      assert_no_selector(".next.disabled")
    end
  end
  
end