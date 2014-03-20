DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  # assumes the following in spec_helper
  #config.use_transactional_fixtures = false
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before :each do
    DatabaseCleaner.start
  end
  config.after :each do
    DatabaseCleaner.clean
  end
end