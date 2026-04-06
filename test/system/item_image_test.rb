require "application_system_test_case"

class ItemImageUploadTest < ApplicationSystemTestCase
  setup do
    sign_in_as_test_user
  end

  # ---------------------------------------------------------------------------
  # Image upload during create
  # ---------------------------------------------------------------------------

  test "can upload an image when creating an item" do
    visit new_item_path

    fill_in "item_title", with: "Item With Photo"
    fill_in "item_brand", with: "PhotoBrand"

    # Attach a generated 1x1 PNG so no external file is needed
    png_path = Rails.root.join("tmp", "test_image.png")
    File.binwrite(png_path, Base64.decode64(
      "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=="
    ))

    attach_file "item_trainimage", png_path.to_s
    click_button "Create Item"

    assert_text "Item With Photo"
    assert_selector "img.img-responsive"
  end

  # ---------------------------------------------------------------------------
  # Image deletion
  # ---------------------------------------------------------------------------

  test "can delete an item's image" do
    # First create an item with an image
    visit new_item_path
    fill_in "item_title", with: "Item Lose Photo"
    fill_in "item_brand", with: "DelBrand"

    png_path = Rails.root.join("tmp", "test_image.png")
    File.binwrite(png_path, Base64.decode64(
      "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=="
    ))
    attach_file "item_trainimage", png_path.to_s
    click_button "Create Item"

    # Now go to edit and delete the image
    assert_text "Item Lose Photo"
    item = Item.find_by(title: "Item Lose Photo")
    visit edit_item_path(item)

    accept_confirm { click_link "Delete image" }

    visit edit_item_path(item)
    assert_no_selector "img.img-responsive"
  end
end
