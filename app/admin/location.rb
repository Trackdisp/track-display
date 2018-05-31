ActiveAdmin.register Location do
  belongs_to :brand, optional: true
  permit_params :name, :brand_id, :channel, :commune_id, :street, :number, device_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :brand
    tag_column :channel
    column :commune
    column :street
    column :number
    column :devices do |location|
      link_to t('active_admin.devices', count: location.devices.count),
        admin_location_devices_path(location)
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :brand
      row :channel, &:channel_text
      row :commune
      row :street
      row :number
      row :devices do |location|
        link_to t('active_admin.devices', count: location.devices.count),
          admin_location_devices_path(location)
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :brand
      f.input :channel, &:channel_text
      f.input :commune
      f.input :street
      f.input :number
      f.input :devices, collection: Device.all.map { |dev| [dev.name || dev.serial, dev.id] }
    end
    f.actions
  end
end
