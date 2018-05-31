class AddReferencesLocationToMeasures < ActiveRecord::Migration[5.1]
  def change
    add_reference :measures, :location, index: true
  end

  def data
    Measure.joins(:device).where.not(devices: { location_id: nil}).each do |measure|
      measure.update(location_id: measure.device.location_id)
    end
  end
end
