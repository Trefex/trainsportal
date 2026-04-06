class AddActiveStorageAndDropPaperclip < ActiveRecord::Migration[7.2]
  def up
    # Create ActiveStorage tables
    create_table :active_storage_blobs do |t|
      t.string   :key,          null: false
      t.string   :filename,     null: false
      t.string   :content_type
      t.text     :metadata
      t.string   :service_name, null: false
      t.bigint   :byte_size,    null: false
      t.string   :checksum
      t.datetime :created_at,   null: false
    end
    add_index :active_storage_blobs, :key, unique: true

    create_table :active_storage_attachments do |t|
      t.string     :name,       null: false
      t.references :record,     null: false, polymorphic: true, index: false
      t.references :blob,       null: false
      t.datetime   :created_at, null: false
    end
    add_index :active_storage_attachments,
              [:record_type, :record_id, :name, :blob_id],
              name: :index_active_storage_attachments_uniqueness,
              unique: true
    add_foreign_key :active_storage_attachments, :active_storage_blobs, column: :blob_id

    create_table :active_storage_variant_records do |t|
      t.belongs_to :blob,        null: false, index: false
      t.string     :variation_digest, null: false
    end
    add_index :active_storage_variant_records, [:blob_id, :variation_digest],
              name: :index_active_storage_variant_records_uniqueness, unique: true
    add_foreign_key :active_storage_variant_records, :active_storage_blobs, column: :blob_id

    # Drop Paperclip columns from items
    remove_column :items, :trainimage_file_name
    remove_column :items, :trainimage_content_type
    remove_column :items, :trainimage_file_size
    remove_column :items, :trainimage_updated_at
    remove_column :items, :trainimage_fingerprint
  end

  def down
    drop_table :active_storage_variant_records
    drop_table :active_storage_attachments
    drop_table :active_storage_blobs

    add_column :items, :trainimage_file_name,    :string
    add_column :items, :trainimage_content_type, :string
    add_column :items, :trainimage_file_size,    :integer
    add_column :items, :trainimage_updated_at,   :datetime
    add_column :items, :trainimage_fingerprint,  :string
  end
end
