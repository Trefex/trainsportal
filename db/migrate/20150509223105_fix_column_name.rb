class FixColumnName < ActiveRecord::Migration[4.2]
  def change
    rename_column :items, :selldata, :selldate
  end
end
