require "test_helper"
require "capybara/rails"
require "capybara/minitest"
require "database_cleaner/active_record"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 900]

  include Capybara::DSL
  include Capybara::Minitest::Assertions

  DatabaseCleaner.strategy = :truncation

  setup do
    # Fully clean all tables first (handles any leftover state from previous tests,
    # including active_storage tables not covered by fixture loading)
    DatabaseCleaner.clean_with(:truncation)
    # Reload fixtures so every test starts with known, consistent data
    ActiveRecord::FixtureSet.reset_cache
    fixtures_path = ActiveRecord::Tasks::DatabaseTasks.fixtures_path
    ActiveRecord::FixtureSet.create_fixtures(fixtures_path, [:users, :items])
  end

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
    DatabaseCleaner.clean
  end

  # Sign in a user via the login form
  def sign_in(email, password)
    visit new_user_session_path
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"
  end

  # Sign in fixture test user and assert the sign-in succeeded
  def sign_in_as_test_user
    sign_in "testuser@example.com", "password123"
    assert_selector "button", text: "Sign out", wait: 5
  end
end
