ActiveAdmin.register WeightMeasure do
  permit_params :device_id, :measured_at, :item_weight, :shelf_weight, :current_weight,
    :previous_weight

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
    column :item_weight
    column :current_weight
    column :previous_weight
    column :items_count
    actions
  end

  show do
    attributes_table do
      row :campaign
      row :measured_at
      row :location
      row :device
      row :item_weight
      row :current_weight
      row :previous_weight
      row :items_count
      row :shelf_weight
    end
  end

  form do |f|
    f.inputs do
      f.input :device
      f.input :measured_at, as: :date_time_picker
      f.input :item_weight
      f.input :current_weight
      f.input :previous_weight
      f.input :shelf_weight
    end
    f.actions
  end
end
