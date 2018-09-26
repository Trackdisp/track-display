class ChangeRotatedFractionToHaveDecimalPrecisionAndScaleInWeightMeasure < ActiveRecord::Migration[5.2]
  def change
    change_column :weight_measures, :rotated_fraction, :decimal, precision: 4, scale: 1
  end
end
