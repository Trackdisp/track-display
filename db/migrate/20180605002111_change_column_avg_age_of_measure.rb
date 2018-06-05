class ChangeColumnAvgAgeOfMeasure < ActiveRecord::Migration[5.1]
  def up
    change_column :measures, :avg_age, :decimal, precision: 4, scale: 1
  end

  def down
    change_column :measures, :avg_age, :integer
  end
end
