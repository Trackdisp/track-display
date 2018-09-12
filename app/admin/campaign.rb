ActiveAdmin.register Campaign do
  permit_params :name, :company_id, :start_date, :end_date, :logo, device_ids: []

  controller do
    defaults finder: :find_by_slug

    def update
      redirect_to_campaign unless nil_or_image?
      super if nil_or_image?
    end

    def create
      redirect_to_campaign unless nil_or_image?
      super if nil_or_image?
    end

    private

    def nil_or_image?
      logo = permitted_params[:campaign][:logo]
      logo.nil? || (logo.content_type&.start_with? 'image')
    end

    def redirect_to_campaign
      redirect_to admin_campaign_path(permitted_params[:campaign]),
        alert: t('active_admin.campaign.errors.not_an_image')
    end
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
        logo = campaign.logo
        image_tag(logo, class: 'campaign__logo') if logo.attached?
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
