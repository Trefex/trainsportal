require "application_system_test_case"

class UserAuthenticationTest < ApplicationSystemTestCase
  # ---------------------------------------------------------------------------
  # Login
  # ---------------------------------------------------------------------------

  test "shows login page" do
    visit new_user_session_path
    assert_selector "h2", text: "Log in"
    assert_selector "input[type=email]"
    assert_selector "input[type=password]"
    assert_selector "input[type=submit][value='Log in']"
  end

  test "successful login redirects to items" do
    sign_in_as_test_user
    assert_current_path root_path
    assert_selector "button", text: "Sign out"
  end

  test "failed login shows error message" do
    sign_in "testuser@example.com", "wrongpassword"
    assert_text "Invalid email or password"
  end

  test "login with unknown email shows error" do
    sign_in "nobody@example.com", "password123"
    assert_text "Invalid email or password"
  end

  # ---------------------------------------------------------------------------
  # Logout
  # ---------------------------------------------------------------------------

  test "can sign out after logging in" do
    sign_in_as_test_user
    click_button "Sign out"
    # After sign out Devise redirects to root; verify we're no longer authenticated
    # by checking that accessing a protected action redirects to login
    visit new_item_path
    assert_current_path new_user_session_path
  end

  # ---------------------------------------------------------------------------
  # Access control: unauthenticated visitors are redirected to login
  # (index and show are public; create/edit/delete require login)
  # ---------------------------------------------------------------------------

  test "unauthenticated user can access the public items index" do
    visit items_path
    assert_selector "table.table"
  end

  test "unauthenticated user is redirected to login for new item" do
    visit new_item_path
    assert_current_path new_user_session_path
  end

  test "unauthenticated user is redirected to login for edit item" do
    visit edit_item_path(1)
    assert_current_path new_user_session_path
  end
end
