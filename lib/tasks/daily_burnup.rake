namespace :charts do
  desc "Update burnup"
  task :burnup => :environment do
    Adapters::TrelloAdapter.daily_burnup.current_progress
  end
end