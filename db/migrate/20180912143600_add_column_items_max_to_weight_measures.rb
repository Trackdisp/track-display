class AddColumnItemsMaxToWeightMeasures < ActiveRecord::Migration[5.2]
  def change
    add_column :weight_measures, :items_max, :integer,  default: 20
  end
end
