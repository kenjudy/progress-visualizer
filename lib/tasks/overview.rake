#*/60 06-18 * * * cd /Users/kenhjudy/dev/progress-visulizer;rake charts:burnup

namespace :tables do
  desc "Update overview"
  task :overview => :environment do
    Tables::Overview.update(Adapters::TrelloAdapter)
  end
end