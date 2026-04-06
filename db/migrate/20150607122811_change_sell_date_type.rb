class ChangeSellDateType < ActiveRecord::Migration[4.2]
  def up
    change_column :items, :selldate, :date
  end

  def down
    change_column :items, :selldate, :datetime
  end
end
