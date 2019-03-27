class ChangeWeightTypesInWeightMeasure < ActiveRecord::Migration[5.2]
  def up
    change_column :weight_measures, :current_weight, :decimal
    change_column :weight_measures, :previous_weight, :decimal
  end

  def down
    change_column :weight_measures, :current_weight, :integer
    change_column :weight_measures, :previous_weight, :integer
  end
end
