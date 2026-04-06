require "application_system_test_case"

class ItemsTest < ApplicationSystemTestCase
  setup do
    sign_in_as_test_user
  end

  # ---------------------------------------------------------------------------
  # Index / listing
  # ---------------------------------------------------------------------------

  test "items index lists items" do
    visit items_path
    assert_selector "table.table"
    assert_selector "td", text: items(:locomotive).title
    assert_selector "td", text: items(:diesel).title
  end

  # ---------------------------------------------------------------------------
  # Show
  # ---------------------------------------------------------------------------

  test "can view item details" do
    visit item_path(items(:locomotive))
    assert_text items(:locomotive).title
    assert_text items(:locomotive).brand
    assert_text items(:locomotive).sn
  end

  # ---------------------------------------------------------------------------
  # Create
  # ---------------------------------------------------------------------------

  test "can create a new item" do
    visit new_item_path
    fill_in "item_title", with: "New Test Locomotive"
    fill_in "item_scale", with: "N"
    fill_in "item_sn", with: "SN-XYZ-999"
    fill_in "item_brand", with: "TestBrand"
    click_button "Create Item"

    assert_text "New Test Locomotive"
  end

  test "shows validation error when title is too short" do
    visit new_item_path
    fill_in "item_title", with: "Hi"  # less than 5 chars
    click_button "Create Item"
    assert_text "error"
  end

  # ---------------------------------------------------------------------------
  # Edit / Update
  # ---------------------------------------------------------------------------

  test "can edit an existing item" do
    visit edit_item_path(items(:locomotive))
    fill_in "item_title", with: "Updated Locomotive Title"
    click_button "Update Item"
    assert_text "Updated Locomotive Title"
  end

  # ---------------------------------------------------------------------------
  # Delete
  # ---------------------------------------------------------------------------

  test "can delete an item" do
    item = items(:diesel)
    item_title = item.title

    # Navigate to the item show page and use the Delete button
    visit item_path(item)
    accept_confirm { click_button "Delete" }

    assert_current_path items_path
    assert_no_selector "td", text: item_title
  end

  # ---------------------------------------------------------------------------
  # Search (requires Solr running on port 8983)
  # ---------------------------------------------------------------------------

  test "search returns matching items" do
    # Reindex fixtures so Solr has current test data
    Item.reindex
    Sunspot.commit

    visit search_items_path(query: items(:locomotive).title)
    assert_selector "td", text: items(:locomotive).title
    assert_no_selector "td", text: items(:diesel).title
  end

  test "search with no results shows empty state" do
    Item.reindex
    Sunspot.commit

    visit search_items_path(query: "zzznomatchwhatsoever")
    assert_no_selector "td", text: items(:locomotive).title
    assert_no_selector "td", text: items(:diesel).title
  end
end
