class AddFieldsToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :sn, :string
    add_column :items, :brand, :string
    add_column :items, :inbox, :boolean
    add_column :items, :scale, :string
    add_column :items, :dateval, :decimal
    add_column :items, :sellprice, :decimal
    add_column :items, :selldata, :datetime
  end
end
