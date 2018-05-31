ActiveAdmin.register Measure do
  permit_params :device_id, :measured_at, :people_count, :views_over_5, :views_over_15,
    :views_over_30, :male_count, :female_count, :avg_age, :happy_count

  filter :device
  filter :campaign
  filter :measured_at
  filter :people_count
  filter :views_over_5

  index do
    selectable_column
    id_column
    column :device
    column :campaign
    column :measured_at
    column :people_count
    column :male_count
    column :female_count
    column :avg_age
    actions
  end

  show do
    attributes_table do
      row :device
      row :campaign
      row :measured_at
      row :people_count
      row :views_over_5
      row :views_over_15
      row :views_over_30
      row :male_count
      row :female_count
      row :avg_age
    end
  end

  form do |f|
    f.inputs do
      f.input :device
      f.input :measured_at, as: :date_time_picker
      f.input :people_count
      f.input :views_over_5
      f.input :views_over_15
      f.input :views_over_30
      f.input :male_count
      f.input :female_count
      f.input :avg_age
      f.input :happy_count
    end
    f.actions
  end
end
