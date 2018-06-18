ActiveAdmin.register Measure do
  permit_params :device_id, :measured_at, :avg_age, :w_id, :presence_duration, :contact_duration,
    :happiness, :gender

  filter :device
  filter :campaign
  filter :campaign_company_id, as: :select, collection: -> { Company.all }
  filter :location
  filter :measured_at

  index do
    selectable_column
    id_column
    column :campaign
    column :measured_at
    column :location
    column :device
    column :avg_age
    column :contact_duration
    column :gender
    column :happiness
    actions
  end

  show do
    attributes_table do
      row :campaign
      row :measured_at
      row :location
      row :device
      row :avg_age
      row :contact_duration
      row :gender
      row :happiness
      row :w_id
      row :presence_duration
    end
  end

  form do |f|
    f.inputs do
      f.input :device
      f.input :measured_at, as: :date_time_picker
      f.input :avg_age
      f.input :contact_duration
      f.input :gender
      f.input :happiness
      f.input :w_id
      f.input :presence_duration
    end
    f.actions
  end
end
