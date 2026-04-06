class ReOrderColumns < ActiveRecord::Migration[4.2]
  def up
    change_column :items, :dateval_date, :datetime, after: :dateval
  end
end
