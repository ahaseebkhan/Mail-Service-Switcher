require './spec_config'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end
WebMock.allow_net_connect!

RSpec.configure do |config|
  require 'database_cleaner'
  require 'factory_bot'

  config.include FactoryBot::Syntax::Methods

  # Clean up the database
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    FactoryBot.find_definitions
  end

  config.before(:context) do
    DatabaseCleaner.start
  end

  config.after(:context) do
    DatabaseCleaner.clean
  end

end
