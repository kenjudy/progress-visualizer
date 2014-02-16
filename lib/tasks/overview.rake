#* 6 * * 1 * * * cd /Users/kenhjudy/dev/progress-visulizer;rake tables:overview

namespace :tables do
  desc "Update overview"
  task :overview => :environment do
    UserProfiles.all.each do |profile|
      Tables::DoneStoriesTable.new(profile).refresh
    end
  end
end