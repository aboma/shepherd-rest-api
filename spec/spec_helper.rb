# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.color_enabled = true

  config.tty = true

  config.formatter = :progress   #:documentation

  config.mock_with :rspec

  config.include JsonSpec::Helpers

  config.include FactoryGirl::Syntax::Methods

  # helpers for Devise authentication
  config.include Devise::TestHelpers, :type => :controller

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.after(:all) do
    # Get rid of the linked images (Carrierwave)
    if Rails.env.test? || Rails.env.cucumber?
      tmp = FactoryGirl.create(:v1_asset)
      store_path = File.dirname(File.dirname(tmp.file.url))
      temp_path = tmp.file.cache_dir
      FileUtils.rm_rf(Dir["#{Rails.root}/public/#{store_path}/[^.]*"])
      FileUtils.rm_rf(Dir["#{temp_path}/[^.]*"])
    end
  end

end
