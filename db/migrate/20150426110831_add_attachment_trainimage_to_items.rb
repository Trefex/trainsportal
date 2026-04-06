class AddAttachmentTrainimageToItems < ActiveRecord::Migration[4.2]
  def self.up
    # Paperclip columns — added manually here for historical record.
    # They are dropped in the ActiveStorage migration (20260406000001).
    add_column :items, :trainimage_file_name,    :string
    add_column :items, :trainimage_content_type, :string
    add_column :items, :trainimage_file_size,    :integer
    add_column :items, :trainimage_updated_at,   :datetime
    add_column :items, :trainimage_fingerprint,  :string
  end

  def self.down
    remove_column :items, :trainimage_file_name
    remove_column :items, :trainimage_content_type
    remove_column :items, :trainimage_file_size
    remove_column :items, :trainimage_updated_at
    remove_column :items, :trainimage_fingerprint
  end
end
