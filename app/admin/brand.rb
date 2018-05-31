ActiveAdmin.register Brand do
  permit_params :name, :channel, location_ids: []

  index do
    selectable_column
    id_column
    column :name
    tag_column :channel
    column :locations do |brand|
      link_to t('active_admin.locations', count: brand.locations.count),
        admin_brand_locations_path(brand)
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :channel, &:channel_text
      row :locations do |brand|
        link_to t('active_admin.locations', count: brand.locations.count),
          admin_brand_locations_path(brand)
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :channel, &:channel_text
      f.input :locations
    end
    f.actions
  end
end
