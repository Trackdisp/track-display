ActiveAdmin.register Campaign do
  permit_params :name, :company_id, :start_date, :end_date, :logo, device_ids: []

  controller do
    defaults finder: :find_by_slug
  end

  filter :name
  filter :company

  index do
    selectable_column
    id_column
    column :name
    column :company
    column :devices do |campaign|
      link_to t('active_admin.devices', count: campaign.devices.count),
        admin_campaign_devices_path(campaign)
    end
    column :start_date
    column :end_date
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :company
      row :devices do |campaign|
        link_to t('active_admin.devices', count: campaign.devices.count),
          admin_campaign_devices_path(campaign)
      end
      row :start_date
      row :end_date
      row :created_at
      row :logo do |campaign|
        image_tag campaign.logo.variant(resize: '100x100') if campaign.logo.attached?
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :company
      f.input :devices, collection: Device.all.map { |dev| [dev.name || dev.serial, dev.id] }
      f.input :start_date, as: :date_picker
      f.input :end_date, as: :date_picker
      f.input :logo, as: :file
    end
    f.actions
  end
end
