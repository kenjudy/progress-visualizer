#*/60 06-18 * * * cd /Users/kenhjudy/dev/progress-visulizer;rake charts:burn_up

namespace :charts do
  desc "Update burn_up"
  task :burn_up => :environment do
    Charts::BurnUpChart.current(Adapters::TrelloAdapter).update
  end
end