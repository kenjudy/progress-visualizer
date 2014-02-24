#* 6 * * 1 * * * cd /Users/kenhjudy/dev/progress-visulizer;rake tables:overview

namespace :tables do
  desc "Update overview"
  task :overview => :environment do
    Tables::DoneStoriesTable.update
  end
end