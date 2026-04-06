class ChangeDateValType < ActiveRecord::Migration[4.2]
  def up
    change_column :items, :dateval_date, :date
  end

  def down
    change_column :items, :dateval_date, :datetime
  end
end
