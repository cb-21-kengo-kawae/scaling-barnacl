require 'database_rewinder'

RSpec.configure do |config|
  config.before :suite do
    DatabaseRewinder.clean
    # or
    # DatabaseRewinder.clean_with :any_arg_that_would_be_actually_ignored_anyway
  end

  config.before(:each) do
    DatabaseRewinder.clean
  end

  config.before(:each, js: true) do
    DatabaseRewinder.strategy = :truncation
  end

  config.after :all do
    DatabaseRewinder.clean
  end
end
