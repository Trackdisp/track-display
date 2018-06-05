class ChangeMeasureColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :measures, :people_count, :integer
    remove_column :measures, :views_over_5, :integer
    remove_column :measures, :views_over_15, :integer
    remove_column :measures, :views_over_30, :integer
    remove_column :measures, :male_count, :integer
    remove_column :measures, :female_count, :integer
    remove_column :measures, :happy_count, :integer

    add_column :measures, :w_id, :string
    add_column :measures, :presence_duration, :decimal, precision: 4, scale: 1
    add_column :measures, :contact_duration, :decimal, precision: 4, scale: 1
    add_column :measures, :happiness, :decimal, precision: 4, scale: 3
    add_column :measures, :gender, :string
  end

  def data
    Measure.destroy_all
  end
end
