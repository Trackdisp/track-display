class AddMeasuresSyncReferencesToMeasure < ActiveRecord::Migration[5.1]
  def change
    add_reference :measures, :measures_sync, foreign_key: true
  end
end
