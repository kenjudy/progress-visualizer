namespace :charts do
  desc "Update burnup"
  task :burnup => :environment do
    Charts::DailyBurnup.current_burnup(Adapters::TrelloAdapter).update_progress
  end
end