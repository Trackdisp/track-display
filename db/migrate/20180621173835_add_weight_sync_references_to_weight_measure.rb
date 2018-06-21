class AddWeightSyncReferencesToWeightMeasure < ActiveRecord::Migration[5.1]
  def change
    add_reference :weight_measures, :weight_measures_sync, index: true
  end
end
