class AddColumnRotatedFractionToWeightMeasures < ActiveRecord::Migration[5.2]
  def change
    add_column :weight_measures, :rotated_fraction, :decimal
  end

  def data
    WeightMeasure.all.each do |wm|
      wm.set_rotated_fraction
      wm.save
    end
  end
end
