class FixDateValueColumnToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :dateval_date, :datetime
  end
end
